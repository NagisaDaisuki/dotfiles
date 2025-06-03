-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- nvim-tree 快捷键
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle File Tree" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { noremap = true, silent = true, desc = "Focus File Tree" })

-- telescope 快捷键
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts) -- 查找所有文件
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts) -- 全局文本搜索
map("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", opts) -- 搜索光标下的单词
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts) -- 已打开的 buffer
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", opts) -- 最近文件

--- LSP相关（需要启用LSP）
map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", opts) -- 引用
map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", opts) -- 定义
map("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", opts) -- 实现
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- 文档符号

--- Git相关
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", opts) -- Git 状态文件
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", opts) -- 提交历史
map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", opts) -- Git 分支

--- 其他有用命令
map("n", "<leader>km", "<cmd>Telescope keymaps<CR>", opts) -- 显示所有快捷键
map("n", "<leader>cm", "<cmd>Telescope commands<CR>", opts) -- 可执行命令
map("n", "<leader>h", "<cmd>Telescope help_tags<CR>", opts) -- Vim 帮助

-- Neogit快捷键
map("n", "<leader>gg", "<cmd>Neogit<CR>", { noremap = true, silent = true, desc = "Open Neogit" })
