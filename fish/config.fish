if status is-interactive
    # Starship custom prompt
    command -v starship &>/dev/null && starship init fish | source

    # Direnv + Zoxide
    command -v direnv &>/dev/null && direnv hook fish | source
    command -v zoxide &>/dev/null && zoxide init fish --cmd cd | source

    # Better ls
    command -v eza &>/dev/null && alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    abbr lg lazygit
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr l ls
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end

    # Custom fish config
    set -q XDG_CONFIG_HOME && set -l cConf $XDG_CONFIG_HOME/caelestia || set -l cConf $HOME/.config/caelestia
    source $cConf/user-config.fish 2>/dev/null

    # enable Vi key mode
    fish_vi_key_bindings

    # 1. make sure Fish uses wl-copy and connect with system clipboard.
    function fish_user_key_bindings
        # 在 visual 模式下按 y，将选中文本写入系统剪贴板
        bind -M visual y 'fish_clipboard_copy; commandline -f end-selection repaint-mode'

        # 在 normal 模式下按 yy，直接将整行命令复制到系统剪贴板
        bind -M default yy 'commandline -b | wl-copy; commandline -f repaint'

        # 在 normal 模式下按 p，从系统剪贴板粘贴到当前位置
        bind -M default p 'commandline -i (wl-paste -n); commandline -f repaint'
    end
end
