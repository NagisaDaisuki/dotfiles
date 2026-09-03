-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    package.loaded["config.matugen_palette"] = nil
    package.loaded["config.matugen_mode"] = nil

    vim.schedule(function()
      pcall(vim.cmd.colorscheme, "matugen_code")

      -- 再强制透明一次，防止插件或 LazyVim 后续覆盖
      local hi = vim.api.nvim_set_hl
      local transparent_groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "FoldColumn",
        "EndOfBuffer",
        "NonText",
        "LineNr",
        "CursorLine",
        "CursorColumn",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NvimTreeNormal",
        "NvimTreeNormalNC",
      }

      for _, group in ipairs(transparent_groups) do
        hi(0, group, { bg = "NONE" })
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(function()
      local hi = vim.api.nvim_set_hl
      local groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "FoldColumn",
        "EndOfBuffer",
        "NonText",
        "LineNr",
        "CursorLine",
        "CursorColumn",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NvimTreeNormal",
        "NvimTreeNormalNC",
      }

      for _, group in ipairs(groups) do
        hi(0, group, { bg = "NONE" })
      end
    end)
  end,
})
