-- 文件：lua/plugins/neogit.lua
return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("neogit").setup({
      integrations = {
        diffview = true, -- 可选，集成 diffview 更好看
      },
    })
  end,
}
