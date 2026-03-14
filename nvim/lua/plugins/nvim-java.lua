-- Java LSP 配置
-- 使用 nvim-jdtls 提供完整的 Java 开发支持

local function get_jdtls_config()
  local home = os.getenv("HOME")
  local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
  local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace"

  vim.fn.mkdir(workspace_dir, "p")

  return {
    cmd = {
      jdtls_path .. "/bin/jdtls",
      "-configuration",
      jdtls_path .. "/config_linux",
      "-data",
      workspace_dir,
    },
    root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git", "settings.gradle" }),
    on_attach = function(client, bufnr)
      -- 使用 nvim-jdtls 的扩展功能
      require("jdtls").setup_dap({ hotcodereplace = "more" })
    end,
    settings = {
      java = {
        -- 格式化设置
        format = {
          settings = {
            url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
          },
        },
        -- 代码片段
        contentProvider = { preferred = "fernflower" },
      },
    },
    -- jdtls 启动参数
    init_options = {
      bundles = {},
    },
  }
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= "" then return end
    if vim.bo[buf].filetype ~= "java" then return end

    local config = get_jdtls_config()
    require("jdtls").start_or_attach(config)
  end,
})

return {
  -- nvim-jdtls: Java 开发增强插件
  { "mfussenegger/nvim-jdtls", ft = "java" },
}
