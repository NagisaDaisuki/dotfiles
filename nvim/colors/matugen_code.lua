-- ~/.config/nvim/colors/matugen_code.lua
-- Matugen Code Theme with transparent editor background

vim.o.termguicolors = true

package.loaded["config.matugen_palette"] = nil
package.loaded["config.matugen_mode"] = nil

local ok_palette, p = pcall(require, "config.matugen_palette")
if not ok_palette then
  p = {
    fg = "#e9e1ec",
    fg_muted = "#cfc3d4",
    bg = "#17131d",
    bg_soft = "#211b28",
    bg_high = "#2b2432",
    bg_highest = "#372e3f",
    primary = "#f0c26e",
    on_primary = "#2b1b00",
    primary_container = "#4a3600",
    on_primary_container = "#ffe2a8",
    secondary = "#cdbdff",
    on_secondary = "#2d2142",
    secondary_container = "#44375a",
    tertiary = "#8bd8ff",
    on_tertiary = "#003544",
    tertiary_container = "#164e5e",
    error = "#ffb4ab",
    on_error = "#690005",
    outline = "#9a8f9f",
  }
end

local ok_mode, mode_mod = pcall(require, "config.matugen_mode")
local mode = ok_mode and mode_mod.mode or vim.o.background or "dark"
local is_dark = mode ~= "light"

vim.o.background = is_dark and "dark" or "light"

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "matugen_code"

local hi = vim.api.nvim_set_hl

-- 代码强调色：跟随壁纸，同时保证比 matugen 默认更像 code theme
local c = {
  fg = p.fg,
  fg_muted = p.fg_muted,

  -- 主编辑区透明，不使用这些 bg
  bg = p.bg,
  bg_soft = p.bg_soft,
  bg_high = p.bg_high,

  -- 语义色
  blue = p.primary,
  purple = p.secondary,
  cyan = p.tertiary,
  red = p.error,

  -- 这些是为“代码可读性”专门设计的固定语义色
  -- 亮色模式用深色，暗色模式用亮色
  green = is_dark and "#8fd694" or "#2f7a3f",
  yellow = is_dark and "#e6c36a" or "#806000",
  orange = is_dark and "#f0a66b" or "#9a4e00",
  pink = is_dark and "#f5a3c7" or "#9b3d68",

  comment = is_dark and "#9d90a7" or "#6e6474",
  border = p.outline,

  float_bg = is_dark and p.bg_soft or p.bg_soft,
  float_fg = p.fg,
}

-- =========================================================
-- Core UI: 主编辑区强制透明
-- =========================================================

hi(0, "Normal", { fg = c.fg, bg = "NONE" })
hi(0, "NormalNC", { fg = c.fg_muted, bg = "NONE" })

hi(0, "SignColumn", { fg = c.fg_muted, bg = "NONE" })
hi(0, "FoldColumn", { fg = c.fg_muted, bg = "NONE" })
hi(0, "EndOfBuffer", { fg = c.fg_muted, bg = "NONE" })
hi(0, "NonText", { fg = c.fg_muted, bg = "NONE" })
hi(0, "Whitespace", { fg = c.fg_muted, bg = "NONE" })

hi(0, "LineNr", { fg = c.comment, bg = "NONE" })
hi(0, "CursorLineNr", { fg = c.yellow, bg = "NONE", bold = true })

-- 不给当前行加实体背景，避免破坏透明
hi(0, "CursorLine", { bg = "NONE" })
hi(0, "CursorColumn", { bg = "NONE" })

hi(0, "ColorColumn", { bg = is_dark and "#2a2430" or "#eee8f0" })

hi(0, "WinSeparator", { fg = c.border, bg = "NONE" })
hi(0, "VertSplit", { fg = c.border, bg = "NONE" })

hi(0, "StatusLine", { fg = c.fg, bg = "NONE" })
hi(0, "StatusLineNC", { fg = c.fg_muted, bg = "NONE" })

hi(0, "TabLine", { fg = c.fg_muted, bg = "NONE" })
hi(0, "TabLineFill", { fg = c.fg_muted, bg = "NONE" })
hi(0, "TabLineSel", { fg = c.yellow, bg = "NONE", bold = true })

-- =========================================================
-- Float / Pmenu: 浮窗保留背景，保证可读性
-- =========================================================

hi(0, "NormalFloat", { fg = c.float_fg, bg = c.float_bg })
hi(0, "FloatBorder", { fg = c.blue, bg = c.float_bg })
hi(0, "FloatTitle", { fg = c.yellow, bg = c.float_bg, bold = true })

hi(0, "Pmenu", { fg = c.float_fg, bg = c.float_bg })
hi(0, "PmenuSel", { fg = p.on_primary_container, bg = p.primary_container, bold = true })
hi(0, "PmenuSbar", { bg = c.bg_high })
hi(0, "PmenuThumb", { bg = c.blue })

-- Neovim 0.10+ completion groups
hi(0, "PmenuExtra", { fg = c.fg_muted, bg = c.float_bg })
hi(0, "PmenuKind", { fg = c.purple, bg = c.float_bg })
hi(0, "PmenuKindSel", { fg = p.on_primary_container, bg = p.primary_container, bold = true })

-- =========================================================
-- Search / Visual
-- =========================================================

hi(0, "Search", { fg = p.on_primary_container, bg = p.primary_container, bold = true })
hi(0, "IncSearch", { fg = p.on_tertiary, bg = c.cyan, bold = true })
hi(0, "CurSearch", { fg = p.on_primary, bg = c.blue, bold = true })

hi(0, "Visual", {
  fg = "NONE",
  bg = is_dark and "#4a3a5e" or "#d8c8ee",
})

hi(0, "MatchParen", {
  fg = c.yellow,
  bg = "NONE",
  bold = true,
  underline = true,
})

-- =========================================================
-- Syntax: Vim 基础高亮
-- =========================================================

hi(0, "Comment", { fg = c.comment, italic = true })

hi(0, "Constant", { fg = c.orange })
hi(0, "String", { fg = c.green })
hi(0, "Character", { fg = c.green })
hi(0, "Number", { fg = c.orange })
hi(0, "Boolean", { fg = c.orange, bold = true })
hi(0, "Float", { fg = c.orange })

hi(0, "Identifier", { fg = c.fg })
hi(0, "Function", { fg = c.blue, bold = true })

hi(0, "Statement", { fg = c.purple })
hi(0, "Conditional", { fg = c.purple, italic = true })
hi(0, "Repeat", { fg = c.purple, italic = true })
hi(0, "Label", { fg = c.purple })
hi(0, "Operator", { fg = c.pink })
hi(0, "Keyword", { fg = c.purple, italic = true })
hi(0, "Exception", { fg = c.red, bold = true })

hi(0, "PreProc", { fg = c.yellow })
hi(0, "Include", { fg = c.purple })
hi(0, "Define", { fg = c.purple })
hi(0, "Macro", { fg = c.yellow })
hi(0, "PreCondit", { fg = c.yellow })

hi(0, "Type", { fg = c.cyan })
hi(0, "StorageClass", { fg = c.cyan })
hi(0, "Structure", { fg = c.cyan })
hi(0, "Typedef", { fg = c.cyan })

hi(0, "Special", { fg = c.pink })
hi(0, "SpecialChar", { fg = c.pink })
hi(0, "Tag", { fg = c.blue })
hi(0, "Delimiter", { fg = c.fg_muted })
hi(0, "SpecialComment", { fg = c.comment, italic = true })
hi(0, "Debug", { fg = c.red })

hi(0, "Underlined", { fg = c.blue, underline = true })
hi(0, "Ignore", { fg = c.fg_muted })
hi(0, "Error", { fg = c.red, bold = true })
hi(0, "Todo", { fg = c.yellow, bg = "NONE", bold = true })

-- =========================================================
-- Tree-sitter
-- =========================================================

hi(0, "@comment", { link = "Comment" })

hi(0, "@variable", { fg = c.fg })
hi(0, "@variable.builtin", { fg = c.orange, italic = true })
hi(0, "@variable.parameter", { fg = c.fg })
hi(0, "@variable.member", { fg = c.cyan })

hi(0, "@constant", { fg = c.orange })
hi(0, "@constant.builtin", { fg = c.orange, bold = true })
hi(0, "@constant.macro", { fg = c.yellow })

hi(0, "@module", { fg = c.yellow })
hi(0, "@label", { fg = c.purple })

hi(0, "@string", { fg = c.green })
hi(0, "@string.escape", { fg = c.pink })
hi(0, "@string.special", { fg = c.pink })

hi(0, "@character", { fg = c.green })
hi(0, "@character.special", { fg = c.pink })

hi(0, "@boolean", { fg = c.orange, bold = true })
hi(0, "@number", { fg = c.orange })
hi(0, "@float", { fg = c.orange })

hi(0, "@type", { fg = c.cyan })
hi(0, "@type.builtin", { fg = c.cyan, bold = true })
hi(0, "@type.definition", { fg = c.cyan })

hi(0, "@attribute", { fg = c.yellow })
hi(0, "@property", { fg = c.cyan })

hi(0, "@function", { fg = c.blue, bold = true })
hi(0, "@function.builtin", { fg = c.blue, bold = true })
hi(0, "@function.call", { fg = c.blue })
hi(0, "@function.macro", { fg = c.yellow })

hi(0, "@constructor", { fg = c.cyan, bold = true })
hi(0, "@operator", { fg = c.pink })

hi(0, "@keyword", { fg = c.purple, italic = true })
hi(0, "@keyword.function", { fg = c.purple, italic = true })
hi(0, "@keyword.operator", { fg = c.pink })
hi(0, "@keyword.return", { fg = c.purple, italic = true })
hi(0, "@keyword.conditional", { fg = c.purple, italic = true })
hi(0, "@keyword.repeat", { fg = c.purple, italic = true })
hi(0, "@keyword.import", { fg = c.purple })

hi(0, "@punctuation.delimiter", { fg = c.fg_muted })
hi(0, "@punctuation.bracket", { fg = c.fg_muted })
hi(0, "@punctuation.special", { fg = c.pink })

hi(0, "@tag", { fg = c.blue })
hi(0, "@tag.attribute", { fg = c.cyan })
hi(0, "@tag.delimiter", { fg = c.fg_muted })

-- =========================================================
-- LSP / Diagnostics
-- =========================================================

hi(0, "DiagnosticError", { fg = c.red })
hi(0, "DiagnosticWarn", { fg = c.yellow })
hi(0, "DiagnosticInfo", { fg = c.cyan })
hi(0, "DiagnosticHint", { fg = c.green })
hi(0, "DiagnosticOk", { fg = c.green })

hi(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hi(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = c.cyan })
hi(0, "DiagnosticUnderlineHint", { undercurl = true, sp = c.green })

hi(0, "LspReferenceText", { bg = is_dark and "#332a3b" or "#e7dced" })
hi(0, "LspReferenceRead", { bg = is_dark and "#332a3b" or "#e7dced" })
hi(0, "LspReferenceWrite", { bg = is_dark and "#43304a" or "#dfcbe8" })

-- =========================================================
-- Git / Diff
-- =========================================================

hi(0, "DiffAdd", { fg = c.green, bg = "NONE" })
hi(0, "DiffChange", { fg = c.yellow, bg = "NONE" })
hi(0, "DiffDelete", { fg = c.red, bg = "NONE" })
hi(0, "DiffText", { fg = c.blue, bg = "NONE", bold = true })

hi(0, "Added", { fg = c.green })
hi(0, "Changed", { fg = c.yellow })
hi(0, "Removed", { fg = c.red })

hi(0, "GitSignsAdd", { fg = c.green, bg = "NONE" })
hi(0, "GitSignsChange", { fg = c.yellow, bg = "NONE" })
hi(0, "GitSignsDelete", { fg = c.red, bg = "NONE" })

-- =========================================================
-- Common plugins
-- =========================================================

-- Telescope
hi(0, "TelescopeNormal", { fg = c.float_fg, bg = c.float_bg })
hi(0, "TelescopeBorder", { fg = c.blue, bg = c.float_bg })
hi(0, "TelescopePromptNormal", { fg = c.float_fg, bg = c.float_bg })
hi(0, "TelescopePromptBorder", { fg = c.yellow, bg = c.float_bg })
hi(0, "TelescopeSelection", { fg = c.yellow, bg = is_dark and "#332a3b" or "#e8d9ee", bold = true })
hi(0, "TelescopeMatching", { fg = c.orange, bold = true })

-- WhichKey
hi(0, "WhichKey", { fg = c.blue })
hi(0, "WhichKeyGroup", { fg = c.purple })
hi(0, "WhichKeyDesc", { fg = c.fg })
hi(0, "WhichKeyFloat", { fg = c.float_fg, bg = c.float_bg })
hi(0, "WhichKeyBorder", { fg = c.blue, bg = c.float_bg })

-- Lazy
hi(0, "LazyNormal", { fg = c.float_fg, bg = c.float_bg })
hi(0, "LazyButton", { fg = c.fg, bg = "NONE" })
hi(0, "LazyButtonActive", { fg = c.yellow, bg = is_dark and "#332a3b" or "#e8d9ee", bold = true })

-- Neo-tree / Nvim-tree 主区域透明
hi(0, "NeoTreeNormal", { fg = c.fg, bg = "NONE" })
hi(0, "NeoTreeNormalNC", { fg = c.fg_muted, bg = "NONE" })
hi(0, "NeoTreeEndOfBuffer", { fg = c.fg_muted, bg = "NONE" })
hi(0, "NeoTreeDirectoryName", { fg = c.blue, bold = true })
hi(0, "NeoTreeDirectoryIcon", { fg = c.blue })
hi(0, "NeoTreeFileName", { fg = c.fg })
hi(0, "NeoTreeFileNameOpened", { fg = c.yellow, bold = true })

hi(0, "NvimTreeNormal", { fg = c.fg, bg = "NONE" })
hi(0, "NvimTreeNormalNC", { fg = c.fg_muted, bg = "NONE" })
hi(0, "NvimTreeEndOfBuffer", { fg = c.fg_muted, bg = "NONE" })
hi(0, "NvimTreeFolderName", { fg = c.blue, bold = true })
hi(0, "NvimTreeFolderIcon", { fg = c.blue })
hi(0, "NvimTreeOpenedFile", { fg = c.yellow, bold = true })

-- cmp
hi(0, "CmpItemAbbr", { fg = c.fg, bg = "NONE" })
hi(0, "CmpItemAbbrDeprecated", { fg = c.comment, bg = "NONE", strikethrough = true })
hi(0, "CmpItemAbbrMatch", { fg = c.blue, bg = "NONE", bold = true })
hi(0, "CmpItemAbbrMatchFuzzy", { fg = c.cyan, bg = "NONE", bold = true })
hi(0, "CmpItemKind", { fg = c.purple, bg = "NONE" })
hi(0, "CmpItemMenu", { fg = c.comment, bg = "NONE" })

-- Mason
hi(0, "MasonNormal", { fg = c.float_fg, bg = c.float_bg })
hi(0, "MasonHeader", { fg = p.on_primary, bg = c.blue, bold = true })
hi(0, "MasonHighlight", { fg = c.blue })
hi(0, "MasonHighlightBlock", { fg = p.on_primary, bg = c.blue })

-- Notify / noice 常见组
hi(0, "NotifyBackground", { bg = c.float_bg })
hi(0, "NoiceCmdlinePopup", { fg = c.float_fg, bg = c.float_bg })
hi(0, "NoiceCmdlinePopupBorder", { fg = c.blue, bg = c.float_bg })
