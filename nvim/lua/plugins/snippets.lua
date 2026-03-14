-- Java Snippets: main + Tab 生成完整类
local function get_class_name()
  local file = vim.fn.expand("%:t:r")
  return file ~= "" and file or "Main"
end

return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    opts = {
      enable_autosnippets = true,
    },
    config = function(_, opts)
      local ls = require("luasnip")
      ls.setup(opts)

      -- Java Snippets
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local rep = require("luasnip.extras").rep

      ls.add_snippets("java", {
        s("main", {
          t("public class "),
          f(get_class_name, {}),
          t(" {\n"),
          t("    public static void main(String[] args) {\n"),
          t("        "),
          i(1, "// code"),
          t("\n"),
          t("    }\n"),
          t("}"),
        }),

        s("psvm", {
          t("public class "),
          f(get_class_name, {}),
          t(" {\n"),
          t("    public static void main(String[] args) {\n"),
          t("        "),
          i(1, "// code"),
          t("\n"),
          t("    }\n"),
          t("}"),
        }),

        s("sout", {
          t("System.out.println("),
          i(1, ""),
          t(");"),
        }),
      })
    end,
  },
}
