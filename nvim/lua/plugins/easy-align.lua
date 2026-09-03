return {
  "junegunn/vim-easy-align",
  event = "VeryLazy",
  config = function()
    -- 🧙‍♂️ 核心黑魔法：自定义分隔符字典
    vim.g.easy_align_delimiters = {
      ["/"] = {
        pattern = [[//]], -- 匹配 C++ 的双斜杠
        ignore_groups = { "String" }, -- 默认是 {'String', 'Comment'}，我们干掉 Comment，允许它操作注释！
      },
    }

    -- 按键绑定
    vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign in visual mode" })
    vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign with motion" })
  end,
}
