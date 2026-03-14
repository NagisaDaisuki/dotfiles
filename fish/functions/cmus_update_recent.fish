function cmus_update_recent
    set MUSIC_DIR ~/Music/WinMusic/
    set PLAYLIST ~/.config/cmus/playlists/recent.pl

    echo "根据 WinMusic 远程文件夹内音乐生成最近添加列表..."
    find $MUSIC_DIR -type f -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2- >$PLAYLIST

    # 通知 cmus 刷新（如果 cmus 正在运行）
    cmus-remote -C "pl-import $PLAYLIST"
    echo "完成！已导入 cmus View 3。"
end
