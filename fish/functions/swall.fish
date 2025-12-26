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
