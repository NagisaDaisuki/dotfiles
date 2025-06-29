if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
end

# ---------------------- -----------------------------------------
# 设置alias 
# ---------------------- -----------------------------------------

#alias pamcan pacman
#alias ll 'ls -lha | lolcat'

function ll
    ls -lha | lolcat
end

function shgo
    sh
end

function sw_paper
    sh ~/Public/scripts/swww/swww_switch_30min_with_wal.sh &>/dev/null
end

function s
    fastfetch | lolcat
end
# funcsave s

function fk
    sudo pacman -Syu 2>&1 | grep -v 'is newer than'
end

function fky
    yay -Syu --devel --sudoloop --noconfirm --answerdiff=None --answerclean=None --removemake
end

function clip
    sh ~/Public/scripts/cliphist/cliphist.sh &>/dev/null
end

function cls
    clear
end
# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end

# ---------------------- -----------------------------------------
# 设置 环境变量
# ---------------------- -----------------------------------------
set -x EDITOR vim
set -x VISUAL vim
