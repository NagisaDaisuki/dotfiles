-- install without yarn or npm
--return {
--  "iamcco/markdown-preview.nvim",
--  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
--  ft = { "markdown" },
--  build = function()
--    vim.fn["mkdp#util#install"]()
--  end,
--}

--- install with yarn or npm
return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  -- 配置部分
  config = function()
    -- 1. 定义一个用于存储 localStorage 数据的路径
    -- vim.fn.stdpath('data') 会解析到 ~/.local/share/nvim/
    local storage_file_path = vim.fn.stdpath("data") .. "/mkdp_local_storage.json"

    -- 2. 设置 mkdp_command_for_node 变量，强制 Node.js 传入必要的参数
    -- 注意：使用单引号或双引号包裹整个字符串
    vim.g.mkdp_command_for_node = "node --localstorage-file=" .. storage_file_path

    -- 可选：设置其他常用配置
    vim.g.mkdp_auto_start = 0 -- 默认不自动启动
    vim.g.mkdp_command_for_external = "google-chrome" -- 使用 Chrome/Chromium
  end,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
}
