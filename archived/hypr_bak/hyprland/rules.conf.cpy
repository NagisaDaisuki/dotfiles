# ######## Window rules ########
# windowrule = noblur,.* //1
# windowrule = opacity 0.89 override 0.89 override, .* # Applies transparency to EVERY WINDOW
# windowrule = float, ^(blueberry.py)$ //2
# windowrule = float, ^(steam)$ //3 
# windowrule = float, ^(guifetch)$ # FlafyDev/guifetch //4 

windowrulev2 = tile, class:(dev.warp.Warp)
windowrulev2 = float, title:^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$
windowrulev2 = center, title:^(Open File)(.*)$
windowrulev2 = center, title:^(Select a File)(.*)$
windowrulev2 = center, title:^(Choose wallpaper)(.*)$
windowrulev2 = center, title:^(Open Folder)(.*)$
windowrulev2 = center, title:^(Save As)(.*)$
windowrulev2 = center, title:^(Library)(.*)$
windowrulev2 = center, title:^(File Upload)(.*)$

# Dialogs
windowrulev2 = float, title:^(Open File)(.*)$
windowrulev2 = float, title:^(Select a File)(.*)$
windowrulev2 = float, title:^(Choose wallpaper)(.*)$
windowrulev2 = float, title:^(Open Folder)(.*)$
windowrulev2 = float, title:^(Save As)(.*)$
windowrulev2 = float, title:^(Library)(.*)$
windowrulev2 = float, title:^(File Upload)(.*)$

# Tearing
# windowrule=immediate,.*\.exe // 5
windowrulev2=immediate,class:(steam_app)

# No shadow for tiled windows
windowrulev2 = noshadow,floating:0


###################################################################################################
#############################       Linux应用窗口设置       #######################################
###################################################################################################

# 让Firefox 浏览器浮动并居中显示，大小为 1200x800
# windowrulev2 = float, class:^(firefox)$
# windowrulev2 = size 1200 800, class:^(firefox)$
# windowrulev2 = center, class:^(firefox)$

# --- LinuxQQ 完美规则 ---
# 1. 主窗口：允许一点点透明 (可选)
windowrulev2 = opacity 0.95 0.95, class:^(QQ)$

# 2. 图片查看器/设置窗口/历史记录：强制浮动并居中
# QQ 的图片查看器通常没有 title，或者 title 很奇怪，所以用 class 抓取
# --- LinuxQQ 悬浮窗规则 ---

# 1. 基础类匹配：针对 QQ 应用
# 2. 标题匹配：包含 "聊天记录" 或完全等于 "设置"

# 强制 "设置" 窗口悬浮并居中
windowrulev2 = float, class:^(QQ)$, title:^(设置)$
windowrulev2 = center, class:^(QQ)$, title:^(设置)$
windowrulev2 = size 800 600, class:^(QQ)$, title:^(设置)$  # 可选：强制设定大小，防止太小

# 强制 "聊天记录" 窗口悬浮并居中
# 使用 .*(聊天记录).* 正则，因为标题可能包含 "与 xxx 的聊天记录"
windowrulev2 = float, class:^(QQ)$, title:.*(聊天记录).*
#windowrulev2 = center, class:^(QQ)$, title:.*(聊天记录).*
windowrulev2 = size 900 700, class:^(QQ)$, title:.*(聊天记录).*

# --- QQ 全套补全规则 ---

# 图片查看器 (必须浮动，否则会被拉伸)
windowrulev2 = float, class:^(QQ)$, title:^(图片查看器)$
windowrulev2 = center, class:^(QQ)$, title:^(图片查看器)$

# 某些版本的图片查看器 title 是空的，可以通过这个规则兜底：
windowrulev2 = float, class:^(QQ)$, title:^$

# 转发消息/选择联系人窗口
windowrulev2 = float, class:^(QQ)$, title:^(转发)$
windowrulev2 = float, class:^(QQ)$, title:^(选择联系人)$

# 接收文件/发送文件窗口
windowrulev2 = float, class:^(QQ)$, title:^(发送文件)$
windowrulev2 = float, class:^(QQ)$, title:^(接收文件)$

# 登录窗口 (如果你重新登录的话)
windowrulev2 = float, class:^(QQ)$, title:^(QQ)$

windowrulev2 = float, class:^(QQ)$, title:^(暂无新消息)$

# 3. 解决部分弹窗太小或位置不对的问题
# windowrulev2 = center, class:^(QQ)$, floating:1

# 4. 如果你想让 QQ 截图功能正常 (QQ截图通常会创建一个全屏覆盖层)
# 但 Hyprland 自带截图更好用，建议不用 QQ 自带截图
# windowrulev2 = fullscreen, class:^(QQ)$, title:^(截图)$


# steam 浮动 居中显示 1920x1080
windowrulev2 = float, class:^(steam)$
windowrulev2 = size 1920 1080, class:^(steam)$
windowrulev2 = center, class:^(steam)$

# --- Steam 修复规则 ---

# 1. 强制 Steam 的所有菜单、下拉框、提示框浮动，且不获取焦点
windowrulev2 = float, class:^(steam)$, title:^(Friends List)$
windowrulev2 = float, class:^(steam)$, title:^(Steam - News)$
windowrulev2 = float, class:^(steam)$, title:^()$ 
# title为空通常是右键菜单，强制浮动

# 2. 禁止 Steam 菜单变得透明/模糊 (解决渲染花屏)
# 这里的 noblur 和 noanim (无动画) 能解决很多怪异显示
windowrulev2 = noblur, class:^(steam)$
windowrulev2 = noanim, class:^(steam)$, title:^()$

# 3. 解决鼠标点击失效/穿透问题 (让菜单保持置顶)
windowrulev2 = stayfocused, title:^()$, class:^(steam)$
windowrulev2 = minsize 1 1, title:^()$, class:^(steam)$



# 1. 最小化启动规则：将 Motrix 发送到工作区 9
# 'silent' 确保 Hyprland 不会自动切换到工作区 9
# 'class:Motrix' 是匹配 Motrix 窗口的关键，你需要替换成你的程序类名
# windowrule = workspace 9 silent, size 1200 800, class:Motrix


# 让 nwg-look 浮动 move 200 200，大小为 1200x800
windowrulev2 = float, class:^(nwg-look)$
windowrulev2 = size 1200 800, class:^(nwg-look)$
windowrulev2 = move 200 200, class:^(nwg-look)$
windowrulev2 = animation popin 70%, class:^(nwg-look)$


# 让 blueman-manager 浮动 move 200 200显示 大小为 1200x800
windowrulev2 = float, class:^(blueman-manager)$
windowrulev2 = size 1200 800, class:^(blueman-manager)$
windowrulev2 = move 200 200, class:^(blueman-manager)$
windowrulev2 = animation popin 70%, class:^(blueman-manager)$
# windowrulev2 = center, class:^(blueman-manager)$

# 让 Gwenview  浮动并居中显示，大小为 1200x800
windowrulev2 = float, class:^(gwenview)$
windowrulev2 = size 1200 800, class:^(gwenview)$
windowrulev2 = center, class:^(gwenview)$
#windowrulev2 = animation popin 70%, class:^(gwenview)$

# 让 Nautilus 浮动并居中显示，大小为 1200x800
windowrulev2 = float, class:^(org.gnome.Nautilus)$
windowrulev2 = size 1200 800, class:^(org.gnome.Nautilus)$
windowrulev2 = center, class:^(org.gnome.Nautilus)$
windowrulev2 = animation popin 70%, class:^(org.gnome.Nautilus)$

# 让 Swayimg  浮动并居中显示
windowrulev2 = float, class:^(swayimg)$
windowrulev2 = center, class:^(swayimg)$
windowrulev2 = animation popin 70%, class:^(swayimg)$

# 让 pavucontrol  浮动 move 100 100 显示，大小为 1200x800
windowrulev2 = float, class:^(org.pulseaudio.pavucontrol)$
windowrulev2 = size 1200 800, class:^(org.pulseaudio.pavucontrol)$
windowrulev2 = move 100 100, class:^(org.pulseaudio.pavucontrol)$
# windowrulev2 = center, class:^(org.pulseaudio.pavucontrol)$

# 让 dosbox 浮动 move 300 300 显示，大小为 1200x800
#windowrulev2 = float, class:^(dosbox)$
#windowrulev2 = size 1200 800, class:^(dosbox)$
#windowrulev2 = move 300 300, class:^(dosbox)$

# 让 com.jaoushingan.WaydroidHelper 浮动并居中显示，大小为 1280x720
# 在workspace 9工作
windowrulev2 = float, size 1280 720, center, class:^(com.jaoushingan.WaydroidHelper)$
windowrulev2 = workspace 9, class:^(com.jaoushingan.WaydroidHelper)$


# 让 Hillstone  浮动并居中显示，大小为 1280x720
# 在workspace 9工作
windowrulev2 = float, size 1280 720, center, class:^(HillstoneSecureConnect)$
windowrulev2 = workspace 9, class:^(HillstoneSecureConnect)$

###################################################################################################
#############################       Waydroid应用窗口设置     ######################################
###################################################################################################


# 让 Waydroid默认窗口 浮动并居中显示，大小为 720 1280 
windowrulev2 = float, center, class:^(waydroid.*)$
#windowrulev2 = noborder, class:^(waydroid.*)$

# 让 Files 浮动居中显示 720 1280
windowrulev2 = center, class:^(Files)$

# 让 Tieba Lite 浮动居中显示 720 1280
windowrulev2 = center, class:^(waydroid.*)$, title:^(.*tieba.*)$

# 让 waydroid.com.YostarJP.BlueArchive 浮动并居中显示，大小为 1920x1080
# windowrulev2 = float, size 2560 1600, acenter, class:^(waydroid.com.YostarJP.BlueArchive)$

## 让 Pixez 浮动并居中显示，大小为 1920x1080
#windowrulev2 = float, size 1920 1080, center, class:^(waydroid.com.perol.pixez)$
#
# 让 Clash for Android 浮动并居中显示，大小为 720x1280
#windowrulev2 = float, size 720 1280, center, class:^(waydroid.com.github.kr328.clash)$

# ######## Layer rules ########

# --- SwayNC 规则 ---
# 1. 针对“侧边栏面板” (Control Center)
# wiki: blur 需要 [on] 参数 -> 使用 1 表示开启
#layerrule = blur 1, swaync-control-center
#
## wiki: ignore_alpha 需要 [a] 参数 -> 使用 0.5 或其他阈值
## 注意：ignorezero 可能是旧名，如果报错，请改用 ignore_alpha
#layerrule = ignore_alpha 0.5, swaync-control-center
#
## 动画部分通常可以直接写 style，如果报错尝试加引号
#layerrule = animation slide right, swaync-control-center
#
## 2. 针对“右上角弹窗” (Notification Popups)
#layerrule = blur 1, swaync-notification-window
#layerrule = ignore_alpha 0.5, swaync-notification-window
# 1. 针对“侧边栏面板” (Control Center)
#layerrule = blur, swaync-control-center
#layerrule = ignorezero, swaync-control-center
#layerrule = animation slide right, swaync-control-center  # 侧边栏用滑入动画更好看
#
## 2. 针对“右上角弹窗” (Notification Popups)
## 这一行是关键，必须精准指向 swaync-notification-window
#layerrule = blur, swaync-notification-window
#layerrule = ignorezero, swaync-notification-window
#
## 你的 popin 动画可以保留给弹窗
#layerrule = animation popin 80%, swaync-notification-window
#
## rofi
## 告诉 Hyprland：给 Rofi 这个窗口加上模糊
## order 0 表示忽略透明度检查强制模糊
#layerrule = blur, rofi
#layerrule = ignorezero, rofi
#layerrule = animation popin 80%, rofi

