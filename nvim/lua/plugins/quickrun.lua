-- 单文件快速编译运行：不折腾 CMake 时用
-- <F6>  根据文件类型一键编译+运行（结果在下方终端分屏）
--   cpp   → g++ -std=c++20 -Wall -Wextra -g 当前文件 → /tmp/a.out 并运行
--   c     → gcc 同上
--   python/lua/shell → 直接解释执行
vim.keymap.set("n", "<F6>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))

  local cmd
  if ft == "cpp" then
    cmd = "g++ -std=c++20 -Wall -Wextra -g "
      .. file
      .. " -o /tmp/nvim_quick_run && time /tmp/nvim_quick_run"
  elseif ft == "c" then
    cmd = "gcc -Wall -Wextra -g " .. file .. " -o /tmp/nvim_quick_run && time /tmp/nvim_quick_run"
  elseif ft == "python" then
    cmd = "python " .. file
  elseif ft == "lua" then
    cmd = "lua " .. file
  elseif ft == "sh" then
    cmd = "bash " .. file
  else
    vim.notify("没有为 " .. ft .. " 定义快速运行命令", vim.log.levels.WARN)
    return
  end

  -- LazyVim 自带 snacks 终端，直接复用
  Snacks.terminal(cmd, { win = { position = "bottom", height = 0.4 } })
end, { desc = "Quick compile & run current file" })

-- 这个文件只注册快捷键，不是插件，但 lazy 要求模块必须返回一个 table
return {}
