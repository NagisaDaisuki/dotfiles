-- Java LSP 配置
-- 跨平台兼容 (Linux/Windows/macOS)

local function get_jdtls_config()
  local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace"

  vim.fn.mkdir(workspace_dir, "p")

  -- 根据系统选择配置目录
  local config_dir = "config_linux"
  local binary_name = "jdtls"
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    config_dir = "config_win"
    binary_name = "jdtls.bat"
  elseif vim.fn.has("mac") == 1 then
    config_dir = "config_mac"
  end

  return {
    cmd = {
      jdtls_path .. "/bin/" .. binary_name,
      "-configuration",
      jdtls_path .. "/" .. config_dir,
      "-data",
      workspace_dir,
    },
    root_dir = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", "settings.gradle", ".git" }),
    on_attach = function(client, bufnr)
      require("jdtls").setup_dap({ hotcodereplace = "more" })
    end,
    settings = {
      java = {
        format = {
          settings = {
            url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
          },
        },
      },
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
  { "mfussenegger/nvim-jdtls", ft = "java" },
}
