# 使用 ANSI 颜色名称而不是 HEX 代码
# 这样可以利用终端的实时变色能力 (Wal 风格)

# 命令 (Command) -> 使用 Blue (对应 Primary)
set -g fish_color_command blue
# 参数 (Param) -> 使用 Green (对应 Secondary)
set -g fish_color_param green
# 关键字 (Keyword) -> 使用 Magenta
set -g fish_color_keyword magenta
# 引号 (Quote) -> 使用 Yellow
set -g fish_color_quote yellow
# 错误 (Error) -> 使用 Red
set -g fish_color_error red
# 注释 (Comment) -> 使用 Bright Black
set -g fish_color_comment brblack

# 其他基础配置
set -g fish_color_normal normal
set -g fish_color_autosuggestion brblack
set -g fish_color_end magenta
set -g fish_color_operator cyan
set -g fish_color_escape yellow
set -g fish_color_cwd blue
