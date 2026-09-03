function ytdl --description "调用 ytdl.lua 下载视频"
    # 只要求至少 1 个参数，其余全部透传（分辨率 / --audio / --dir <path> 由 lua 解析）
    if test (count $argv) -lt 1
        echo "Usage: ytdl <video_link> [2160/1440/1080/720/480 | --audio] [--dir <path>]" >&2
        return 1
    end

    lua ~/Public/scripts/lua_scripts/my_ytdl/ytdl.lua $argv

    # $status 会被 echo 刷新，必须先存下来再判断
    set res $status
    if test $res -ne 0
        echo "Error: ytdl execute failed! (exit $res)" >&2
        return $res
    end
end
