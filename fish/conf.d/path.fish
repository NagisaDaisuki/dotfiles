# 全局环境变量

# ============================================================

# 用户级可执行文件
fish_add_path -g ~/.local/bin

# 本地 bin目录下的 一些 可执行程序
fish_add_path -g ~/.local/bin/MusicLyric/
# fish_add_path -g ~/.local/bin/
fish_add_path -g ~/.local/bin/realesrgan-ncnn-vulkan-20220424/

# ============================================================

# npm 用户级全局包
fish_add_path -g ~/.local/share/npm/bin

# Rust / Cargo
fish_add_path -g ~/.cargo/bin

# ccache
fish_add_path -g /usr/lib/ccache/bin

# auto-masm
fish_add_path -g ~/.auto-masm/bin

# ============================================================

# opencode
fish_add_path /home/NagiChan/.opencode/bin

# Go 语言配置
set -gx GOPATH $HOME/.local/share/go
fish_add_path $GOPATH/bin
