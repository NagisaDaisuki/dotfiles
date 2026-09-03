-- cmake-tools 快捷键（lang.cmake extra 已提供插件本体，这里只加快捷键）
-- 注意：<leader>cr 是 LazyVim 的 LSP rename，运行用 <leader>ce（execute）
return {
  "Civitasv/cmake-tools.nvim",
  keys = {
    { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
    { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
    { "<leader>ce", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
  },
  opts = {
    cmake_build_directory = "build",
    -- 生成 compile_commands.json 给 clangd 用
    cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
  },
}
