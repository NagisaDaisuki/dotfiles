# 🌟 My Dotfiles Backup

这是我个人在 Linux 系统中的 `~/.config/` 目录下重要配置的备份仓库。用于快速同步、重装还原和版本控制。

---

## 📁 当前备份的配置列表

- `nvim/` - Neovim 配置
- `kitty/` - kitty 终端配置
- `fish/` - Fish Shell 配置

---

## 🛠 快速还原方法（软链接方式）

将这些配置恢复到 `~/.config/`：

```bash
# 设置变量
SRC=$(pwd)
CONFIG_DIR="$HOME/.config"

# 创建软链接
ln -sfn "$SRC/nvim" "$CONFIG_DIR/nvim"
ln -sfn "$SRC/kitty" "$CONFIG_DIR/kitty"
ln -sfn "$SRC/fish" "$CONFIG_DIR/fish"

