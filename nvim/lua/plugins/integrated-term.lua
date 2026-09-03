--[[
--  integrated-term.lua  —  VSCode 风格集成终端（LazyVim / Snacks 版）
--
--  核心能力：在当前文件的【所在目录】打开一个【垂直】终端，
--  并可在 Neovim 内向该终端发送任意命令（编译 / 运行 / gdb / 跑 agent 等）。
--  写完全部操作都在 Neovim 内进行，不用再退出到外部终端。
--
--  快捷键（可用 :map 查看，均带 desc 描述）：
--    <leader>tt  开/关终端（toggle）
--    <leader>to  打开并聚焦终端（强制刷新到当前文件目录）
--    <leader>tr  按文件类型编译并运行（发送到集成终端）
--    <leader>td  用 gdb 调试当前编译产物（发送到集成终端）
--
--  通用：在任何地方调用 IntegratedTerm.run("gcc -o test a.c") 即可发送命令。
--  若要绑定到 autocmd / 其他插件（如 agent 跑 diff 分析），直接用 run()。
]]
local M = {}

-- 记录当前 Snacks 终端对象
M.term = nil
M.dir = nil -- 终端所在的目录

---@return string 当前 buffer 所在目录；无文件名时回退到 Neovim 工作目录
local function buf_dir()
  local name = vim.api.nvim_buf_get_name(0)
  local d = vim.fn.fnamemodify(name, ":h")
  if d == "" then
    d = vim.uv.cwd()
  end
  return d
end

-- 新建一个终端（在参数/当前目录、右侧垂直分屏）
---@param dir? string
local function new_term(dir)
  dir = dir or buf_dir()
  M.dir = dir
  return Snacks.terminal.open(nil, {
    cwd = dir,
    win = { position = "right", width = 0.5, style = "terminal" },
    start_insert = true, -- 打开即进入插入模式
    auto_insert = true, -- 进入终端 buffer 自动插入
  })
end

-- 打开并聚焦终端（若已存在则复用；若目录变了会重开）
---@return snacks.terminal
function M.open()
  local dir = buf_dir()
  -- 目录变化了，关掉旧终端重新开
  if M.term and M.term:buf_valid() and M.dir and M.dir ~= dir then
    M.term:close()
    M.term = nil
  end
  if not (M.term and M.term:buf_valid()) then
    M.term = new_term(dir)
  end
  M.term:show()
  M.term:focus()
  return M.term
end

-- 开关：当前在终端窗口就隐藏，否则显示聚焦
function M.toggle()
  if M.term and M.term:buf_valid() then
    if vim.api.nvim_get_current_buf() == M.term.buf then
      M.term:hide()
    else
      M.term:show()
      M.term:focus()
    end
  else
    M.open()
  end
end

-- 向终端发送一条命令（shell 内容）。确保终端已打开。
---@param cmd string
function M.run(cmd)
  M.open()
  local chan = vim.api.nvim_buf_get_var(M.term.buf, "term_job_id")
  vim.fn.chansend(chan, (cmd or "") .. "\r")
  vim.api.nvim_set_current_win(M.term.win)
  vim.cmd("startinsert")
end

-- 按文件类型构造“编译并运行”命令
local function build_run_cmd()
  local ft = vim.bo.filetype
  local file = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
  local out = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
  if ft == "cpp" then
    return "g++ -std=c++20 -Wall -Wextra -g " .. file .. " -o " .. out .. " && ./" .. out
  elseif ft == "c" then
    return "gcc -Wall -Wextra -g " .. file .. " -o " .. out .. " && ./" .. out
  elseif ft == "python" then
    return "python " .. file
  elseif ft == "lua" then
    return "lua " .. file
  elseif ft == "sh" then
    return "bash " .. file
  else
    vim.notify("没有为 " .. ft .. " 定义编译运行命令", vim.log.levels.WARN)
    return nil
  end
end

-- 编译并运行（发送到集成终端）
function M.compile_run()
  local cmd = build_run_cmd()
  if cmd then
    M.run(cmd)
  end
end

-- 用 gdb 调试当前编译产物
function M.debug()
  local name = vim.api.nvim_buf_get_name(0)
  local bin = vim.fn.fnamemodify(name, ":t:r")
  M.run("gdb ./" .. bin)
end

-- 注册快捷键（LazyVim import 会在启动时执行）
local function map(lhs, fn, desc)
  vim.keymap.set("n", lhs, fn, { desc = desc, silent = true })
end

map("<leader>tt", M.toggle, "终端: 开/关")
map("<leader>to", M.open, "终端: 打开聚焦")
map("<leader>tr", M.compile_run, "终端: 编译并运行")
map("<leader>td", M.debug, "终端: gdb 调试")

-- 注意：返回 {} 与 quickrun 一致——文件副作用（注册快捷键）在 require 时执行。
-- 外部要用 IntegratedTerm.run() 时，直接 require("plugins.integrated-term") 即可。
return {}
