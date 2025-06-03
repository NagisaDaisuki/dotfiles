return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- 图标支持（可选但推荐）
  },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "切换文件树" },
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
        preserve_window_proportions = true,
      },
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      git = {
        enable = true,
      },
      filters = {
        dotfiles = false,
      },
    })
  end,
}
