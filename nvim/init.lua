-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- 设置<leader>为空格
vim.g.mapleader = " "

-- 设置默认启动主题
vim.cmd.colorscheme("gruvbox")

-- 设置背景透明
vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight NormalNC guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight NormalFloat guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight Pmenu guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight FloatBorder guibg=NONE ctermbg=NONE]])
