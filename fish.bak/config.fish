function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)

end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

#starship init fish | source
#if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
#    cat ~/.cache/ags/user/generated/terminal/sequences.txt
#end

# ---------------------- -----------------------------------------
# 设置alias 
# ---------------------- -----------------------------------------

alias pamcan=pacman

function shgo
    sh
end

#function sw_paper
#    sh ~/Public/scripts/swww/swww_switch_30min_with_wal.sh &>/dev/null
#end

function s
    fastfetch
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
