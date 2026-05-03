if status is-interactive

    # 1. 应用终端颜色转义序列
    # 告诉终端模拟器(Kitty / Alacritty) 改变背景色
    #if test -f ~/.cache/wal/sequences.sh
    #    source ~/.cache/wal/sequences.sh
    #end

    # 2. 导入 Fish 专属的变量配置(使用matugen会自动处理语法高亮)
    # Pywal 默认会生成在 color.sh 的同时也生 colors.fish
    # if test -f ~/.cache/wal/colors.fish
    #     source ~/.cache/wal/colors.fish
    # end

    #if test -f ~/.config/fish/conf.d/matugen_colors.fish
    #    source ~/.config/fish/conf.d/matugen_colors.fish
    #end

    # Commands to run in interactive sessions can go here
    set fish_greeting
end

# ---------------------- -----------------------------------------
# 设置alias 
# ---------------------- -----------------------------------------

#alias pamcan pacman
#alias ll 'ls -lha | lolcat'

function cmus_update_recent
    set MUSIC_DIR ~/Music/WinMusic/
    set PLAYLIST ~/.config/cmus/playlists/recent.pl

    echo "根据 WinMusic 远程文件夹内音乐生成最近添加列表..."
    find $MUSIC_DIR -type f -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2- >$PLAYLIST

    # 通知 cmus 刷新（如果 cmus 正在运行）
    cmus-remote -C "pl-import $PLAYLIST"
    echo "完成！已导入 cmus View 3。"
end

# 复制粘贴相关 alias
function wlc
    pwd | wl-copy
end

function wlp
    cd "$(wl-paste)"
end

function ll
    ls -lha | lolcat
end

function shgo
    sh
end

function sw_paper
    sh ~/Public/scripts/awww/awww_switch_bgr.sh &>/dev/null
end

function du_check
    sh ~/Public/scripts/du_check/du_check.sh
end

function sss
    fastfetch
end
# funcsave s

function fk
    sudo pacman -Syu 2>&1 | grep -v 'is newer than'
end

function fky
    yay -Syu --devel --sudoloop --noconfirm --answerdiff=None --answerclean=None --removemake
end

function clip_hist
    sh ~/Public/scripts/cliphist/cliphist.sh &>/dev/null
end

function fish_hist
    sh ~/Public/scripts/cliphist/fishhist.sh &>/dev/null
end

function cls
    clear
end

function wb_restart
    nohup waybar -c ~/.config/waybar/configs/mpris_middle -s ~/.config/waybar/style/islands.css >/dev/null &
end

function swall --description '使用 swww 切换壁纸，接受一个文件路径参数'
    # 1.检查参数数量，有且仅有一个源文件名
    if test (count $argv) -ne 1
        echo "错误：'swall' 命令只接接受一个参数(壁纸文件)"
        echo "用法：'swall' <文件路径>" >&2
        return 1
    end

    set wallpaper_path $argv[1]

    # 2. 检查文件是否存在 
    if not test -f "$wallpaper_path"
        echo "错误：文件未找到或不是一个常规文件：'$wallpaper_path'" >&2
        return 1
    end

    # 3. 执行 swww 切换壁纸命令
    # 使用 --transition-type 和 --transtion-fps 参数创建平滑过渡效果
    set wallpaper_name (basename $wallpaper_path)
    echo "正在切换壁纸到: $wallpaper_name"
    swww img "$wallpaper_path" \
        --transition-type any \
        --transition-fps 120 \
        --transition-duration 1

    # 检查 swww 命令是否执行成功
    if test $status -ne 0
        echo "错误：swww 命令执行失败。" >&2
        return $status
    end
end

function gcc_run_clean --description '带 -Wall -std=gnu11 -g 参数的gcc编译并运行'
    # 检查参数数量。必须至少传入一个源文件名
    if test (count $argv) -lt 1
        echo "用法：gcc_run_clean <源文件名.c> [程序运行参数...]" | lolcat
        return 1
    end

    # ----------------------------------------------------
    # 1. 准备阶段
    # ----------------------------------------------------
    set source_file $argv[1]
    # 自动生成输出文件名 (如：test.c -> test)
    set output_file (basename $source_file .c)

    # 捕获 C 程序的运行参数：从 $argv 的第二个元素到最后一个元素
    set program_args $argv[2..-1]

    # ----------------------------------------------------
    # 2. 编译阶段
    # ----------------------------------------------------
    echo "--- 编译：$source_file ---"
    # 使用安全的 list 结构来构建命令
    set compile_cmd gcc -Wall -g -std=gnu11 $source_file -o $output_file -D_GNU_SOURCE -lrt -lm

    # 直接执行命令（在 Fish 中，直接运行变量列表是安全的）
    $compile_cmd

    # 检查编译是否成功
    if test $status -ne 0
        echo "--- 编译失败，停止执行 ---" | lolcat
        return 1
    end

    # ----------------------------------------------------
    # 3. 运行阶段
    # ----------------------------------------------------
    # 将输出文件名和程序参数连接起来，形成完整的运行命令
    echo "--- 运行：./$output_file $program_args ---"

    # 运行程序并传递所有参数。Fish 会正确地处理 $program_args 列表
    ./$output_file $program_args
    set run_status $status

    # ----------------------------------------------------
    # 4. 清理阶段
    # ----------------------------------------------------
    if test -e $output_file
        echo "--- 清理：删除 $output_file ---"
        rm $output_file
    end

    return $run_status
end

function gcc_run_del
    # 检查参数数量。必须至少传入一个源文件名
    if test (count $argv) -lt 1
        echo "用法：gcc_run_clean <源文件名.c> [程序运行参数...]" | lolcat
        return 1
    end

    # ----------------------------------------------------
    # 1. 准备阶段
    # ----------------------------------------------------
    set source_file $argv[1]
    # 自动生成输出文件名 (如：test.c -> test)
    set output_file (basename $source_file .c)

    # 捕获 C 程序的运行参数：从 $argv 的第二个元素到最后一个元素
    set program_args $argv[2..-1]

    # ----------------------------------------------------
    # 2. 编译阶段
    # ----------------------------------------------------
    echo "--- 编译：$source_file ---"
    # 使用安全的 list 结构来构建命令
    set compile_cmd gcc -Wall -g -std=c11 $source_file -o $output_file

    # 直接执行命令（在 Fish 中，直接运行变量列表是安全的）
    $compile_cmd

    # 检查编译是否成功
    if test $status -ne 0
        echo "--- 编译失败，停止执行 ---" | lolcat
        return 1
    end

    # ----------------------------------------------------
    # 3. 运行阶段
    # ----------------------------------------------------
    # 将输出文件名和程序参数连接起来，形成完整的运行命令
    echo "--- 运行：./$output_file $program_args ---"

    # 运行程序并传递所有参数。Fish 会正确地处理 $program_args 列表
    ./$output_file $program_args
    set run_status $status

    # ----------------------------------------------------
    # 4. 清理阶段
    # ----------------------------------------------------
    if test -e $output_file
        echo "--- 清理：删除 $output_file 和 $source_file---"
        rm $output_file
        rm $source_file
    end

    return $run_status
end

# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end

# 设置代理开关
#function proxy_on
#    set -x http_proxy http://127.0.0.1:7890
#    set -x https_proxy http://127.0.0.1:7890
#    set -x ftp_proxy http://127.0.0.1:7890
#    set -x all_proxy socks5://127.0.0.1:7890
#    echo "Proxy ON"
#end
#
#function proxy_off
#    set -e http_proxy
#    set -e https_proxy
#    set -e ftp_proxy
#    set -e all_proxy
#    echo "Proxy OFF"
#end

# ---------------------- -----------------------------------------
# 设置 环境变量
# ---------------------- -----------------------------------------

# 设置PATH
set -gx PATH $PATH ~/.npm_global/bin ~/Public/realesrgan/ ~/.auto-masm/bin

# 设置GOOGLE_CLOUD_PROJECT_ID
set -gx GOOGLE_CLOUD_PROJECT coral-trilogy-474906-t3
# set -gx GOOGLE_CLOUD_PROJECT project-06c35014-907e-42fa-b99

# 设置默认编辑文本文件工具
set -gx EDITOR nvim
set -gx SYSTEMD_EDITOR vim
set -gx VISUAL code

# 设置代理
set -x http_proxy "http://127.0.0.1:7890"
set -x https_proxy "http://127.0.0.1:7890"
set -x ftp_proxy "http://127.0.0.1:7890"
set -x all_proxy "http://127.0.0.1:7890" # 需要SOCKS5
set -x no_proxy "localhost,127.0.0.1,::1,*.local,*.lan,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12" # 排除不需要走代理的地址

# 大写变量名
set -x HTTP_PROXY $http_proxy # 复制小写的值给大写
set -x HTTPS_PROXY $https_proxy
set -x FTP_PROXY $ftp_proxy
set -x ALL_PROXY $all_proxy
set -x NO_PROXY $no_proxy

## Source Pywal colors.sh if it exists (for LS_COLORS and other shell variables)
# if test -f ~/.cache/wal/colors.sh
# Fish shell doesn't use 'source' or 'export' in the same way.
# We execute the script using bash and capture the necessary LS_COLORS variable.
# (This is a common workaround for scripts designed for Bash/Zsh)

# Note: If colors.sh only contains 'background', 'foreground', and 'LS_COLORS', 
# you might be able to manually convert and set them with 'set -gx VAR VALUE'.

# For simplicity and robustness, ensure the script is run when Fish starts.
# A cleaner solution (if available) is using a dedicated fish-wal plugin or template.

# Option A: A common workaround (needs Pywal to provide a Fish template):
# If your Pywal supports a 'colors.fish' template, include that instead.
#    source ~/.cache/wal/colors.fish

# Option B: Manual setting (Only works if your theme is simple)
# The best practice is to install a dedicated Fish Pywal plugin like 'fish-wal' or 'oh-my-fish/theme-wal'.

# Since you showed a colors.sh, let's stick to the official Pywal solution:
# Pywal should be configured to generate a 'colors.fish' or you use a dedicated plugin.

# --- 最佳实践：使用 Pywal 提供的 Fish 模板（如果可用） ---
# Pywal 默认会生成一个 colors.sh，但你可以配置它生成 colors.fish
# 如果你确定你的Pywal生成了colors.fish:
# source ~/.cache/wal/colors.fish

# --- 如果你只使用colors.sh，并想让LS_COLORS生效（不太推荐，但可行） ---
# 理论上，Fish应该能继承父进程的环境变量，但Shell启动时通常不是这样。
# 最稳健的方案是安装一个Fish插件。
#end
