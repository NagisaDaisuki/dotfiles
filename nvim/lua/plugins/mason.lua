return {
  {
    "mason-org/mason.nvim",
    version = false,
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "jdtls",
        "java-test",
        "java-debug-adapter",
        "clangd",
        "clang-format",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        local unique_tools = {}
        local installed_map = {}
        for _, tool in ipairs(opts.ensure_installed) do
          if not installed_map[tool] then
            installed_map[tool] = true
            table.insert(unique_tools, tool)
          end
        end

        for _, tool in ipairs(unique_tools) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() and not p:is_installing() then
            p:install()
          end
        end
      end)
    end,
  },
}
