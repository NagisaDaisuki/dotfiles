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
    -- 单步调试
    vim.keymap.set("n", "<F10>", function()
      dap.step_over()
    end, { desc = "Step Over" })
    vim.keymap.set("n", "<F11>", function()
      dap.step_into()
    end, { desc = "Step Into" })
    vim.keymap.set("n", "<S-F11>", function()
      dap.step_out()
    end, { desc = "Step Out" })

    -- ── C/C++ 调试：使用 Mason 安装的 codelldb ──
    -- 先执行 :MasonInstall codelldb
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = mason_bin .. "/codelldb",
        args = { "--port", "${port}" },
      },
    }

    local common_config = {
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    }
    dap.configurations.cpp = {
      -- 方式一：调试当前 CMake 项目（cmake-tools 构建产物）
      vim.tbl_extend("force", common_config, {
        name = "Launch (workspace binary)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("可执行文件路径: ", vim.fn.getcwd() .. "/build/", "file")
        end,
        args = function()
          local input = vim.fn.input("程序参数(留空跳过): ")
          return vim.split(input, " ", { trimempty = true })
        end,
      }),
    }
    dap.configurations.c = dap.configurations.cpp
  end,
}
