function wb_restart
    nohup waybar -c ~/.config/waybar/configs/mpris_middle -s ~/.config/waybar/style/islands.css >/dev/null &
end
