return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    -- 在这里直接绑定你喜欢的调试快捷键即可，不需要调用 setup()
    -- 例如，绑定 <F5> 为启动/继续调试：
    vim.keymap.set("n", "<F5>", function()
      dap.continue()
    end)
    -- 绑定 <Leader>b 为打断点：
    vim.keymap.set("n", "<Leader>b", function()
      dap.toggle_breakpoint()
    end)
  end,
}
