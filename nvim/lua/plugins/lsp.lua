-- 简化版 LSP 配置
-- 使用 LazyVim 自带的 LSP 配置，只添加额外的 symbols-outline
-- C/C++: LazyVim 自带 clangd 配置
-- Java: nvim-java.lua 单独处理

return {
  -- symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      position = "right",
    },
  },
}
