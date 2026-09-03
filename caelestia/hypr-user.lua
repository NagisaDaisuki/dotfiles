local vars = require("variables")

-- ============================
-- 显示器覆盖：eDP-1 用整数缩放避免 Caelestia 侧边栏模糊
-- ============================
hl.monitor({
	output = "eDP-1",
	mode = "2560x1600@120",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
})

-- ============================
-- 外接显示器：HDMI-A-1 4K 配置(扩展在右侧)
-- ============================

hl.monitor({
	output = "HDMI-A-1",
	mode = "3840x2160@120",
	--mirror = "eDP-1", -- 将该屏幕设置为 eDP-1 的镜像 / 复制
	position = "2560x0",
	scale = 1,
	bitdepth = 10,
})

-- ============================
-- 自定义快捷键
-- ============================

-- SUPER + mouse:273 (右键拖动): 调整窗口大小（Caelestia 已默认绑定）
-- SUPER + mouse:272 (左键拖动): 移动窗口（Caelestia 已默认绑定）
-- create_bind({ vars.kbMoveWindow, "SUPER + mouse:272" }, hl.dsp.window.drag(), mouse)
-- create_bind({ vars.kbResizeWindow, "SUPER + SHIFT + mouse:273" }, hl.dsp.window.resize(), mouse)
-- hl.bind("SUPER + SHIFT + mouse:272",)

-- SUPER+Return: 浮动终端
hl.bind("SUPER + Return", function()
	hl.exec_cmd("kitty --class floatterm")
end)

-- 覆盖 Caelestia 默认：移动窗口到工作区 SUPER+SHIFT+1-9（替代 SUPER+ALT）
for i = 1, 9 do
	hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- SUPER+Tab: 切换 overview
-- hl.bind("SUPER + Tab", function()
-- 	hl.exec_cmd("qs -p $HOME/.config/quickshell/overview ipc call overview toggle")
-- end)

-- SUPER+K: 重启 quickshell panel（旧习惯）
-- hl.bind("SUPER + K", function()
-- 	hl.exec_cmd("systemctl --user restart quickshell quickshell-overview")
-- end)

-- SUPER+SHIFT+W: 切换壁纸
hl.bind("SUPER + SHIFT + W", function()
	hl.exec_cmd("fish -c sw_paper")
end)

-- VIM 风格 HJKL focus（不影响Caelestia箭头键）
-- hl.bind("SUPER + SHIFT + H", function()
-- 	hl.dsp.focus({ direction = "l" })
-- end)
-- hl.bind("SUPER + SHIFT + J", function()
-- 	hl.dsp.focus({ direction = "d" })
-- end)
-- hl.bind("SUPER + SHIFT + K", function()
-- 	hl.dsp.focus({ direction = "u" })
-- end)
-- hl.bind("SUPER + SHIFT + L", function()
-- 	hl.dsp.focus({ direction = "r" })
-- end)

-- 锁屏
-- hl.bind("SUPER + L", function()
-- 	hl.exec_cmd("pidof hyprlock || hyprlock")
-- end)

-- 剪贴板历史
-- hl.bind("SUPER + SHIFT + V", function()
-- 	hl.exec_cmd("fish -c clip_hist")
-- end)

-- SUPER+SHIFT+C: fish history
-- hl.bind("SUPER + SHIFT + C", function()
-- 	hl.exec_cmd("fish -c fish_hist")
-- end)

-- 截图
-- hl.bind("SUPER + SHIFT + S", function()
-- 	hl.exec_cmd("~/Public/scripts/screenshot/screenshot.sh region")
-- end)

-- ============================
-- floatterm 窗口规则
-- ============================
-- hl.window_rule({
-- 	match = { class = "floatterm" },
-- 	float = true,
-- 	center = true,
-- 	size = "1600 1200",
-- })

-- ============================
-- 自定义窗口规则（不覆盖 Caelestia 默认 rules.lua）
-- ============================

-- QQ
hl.window_rule({ match = { class = "QQ", title = "图片查看器" }, float = true })
hl.window_rule({ match = { class = "QQ", title = "设置" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ", title = "转发" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ", title = "选择联系人" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ", title = "发送文件" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ", title = "接收文件" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ", title = "QQ" }, float = true, center = true })

-- WeChat
-- hl.window_rule({ match = { class = "wechat" }, float = true, center = true })
-- hl.window_rule({
-- 	match = { class = "wechat", title = "Photos and Videos" },
-- 	float = true,
-- 	center = true,
-- 	size = "618 720",
-- })
-- hl.window_rule({
-- 	match = { class = "wechat", title = "图片和视频" },
-- 	float = true,
-- 	center = true,
-- })
-- hl.window_rule({ match = { class = "wechat", title = "" }, float = true, center = true })

-- Telegram
-- hl.window_rule({
-- 	match = { class = "org.telegram.desktop", title = "Telegram" },
-- 	float = true,
-- 	size = "960 600",
-- 	center = true,
-- })

-- Kitty 不叠加 Hyprland opacity，由 kitty 自己的 background_opacity 控制透明
-- 这样文字保持清晰，只有背景透明
-- hl.window_rule({ match = { class = "kitty" }, opacity = "1.0 1.0" })

-- Pixiv-MultiPlatform
hl.window_rule({ match = { title = "Pixiv-MultiPlatform" }, float = true, size = "1600 900", center = true })

-- MPV
hl.window_rule({ match = { class = "mpv" }, opacity = "1.0 1.0" })

-- Swayimg
hl.window_rule({ match = { class = "swayimg" }, float = true, center = true })

-- Gwenview
hl.window_rule({ match = { class = "gwenview" }, float = true, size = "960 600", center = true })

-- Nautilus 文件管理器
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, float = true, size = "960 600", center = true })

-- Pavucontrol 音量控制
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, size = "960 600", opacity = 1.0 })

-- qBittorrent → 工作区9
hl.window_rule({ match = { class = "org.qbittorrent.qBittorrent" }, float = true, size = "960 600", center = true })

-- Hillstone VPN → 工作区9
hl.window_rule({ match = { class = "HillstoneSecureConnect" }, float = true, size = "960 600", center = true })

-- Satty 截图编辑
hl.window_rule({ match = { class = "com.gabm.satty" }, float = true, size = "1200 800", center = true })

-- nwg-look GTK主题
hl.window_rule({ match = { class = "nwg-look" }, float = true, size = "960 600", center = true })

-- blueman-manager
hl.window_rule({ match = { class = "blueman-manager" }, float = true, size = "960 600", center = true })

-- 通用对话框浮动
hl.window_rule({ match = { title = "Open File" }, float = true, center = true })
hl.window_rule({ match = { title = "Select a File" }, float = true, center = true })
hl.window_rule({ match = { title = "Choose wallpaper" }, float = true, center = true })
hl.window_rule({ match = { title = "Open Folder" }, float = true, center = true })
hl.window_rule({ match = { title = "Save As" }, float = true, center = true })
hl.window_rule({ match = { title = "Library" }, float = true, center = true })
hl.window_rule({ match = { title = "File Upload" }, float = true, center = true })

-- ============================
-- 开机自启动
-- ============================
hl.on("hyprland.start", function()
	hl.exec_cmd("fcitx5")
	hl.exec_cmd("hypridle")
	hl.exec_cmd('echo "" > /home/NagiChan/.config/hypr/conf/custom/lid_state.conf')
	-- Pick a random wallpaper via Caelestia (fade+scale transition)
	hl.exec_cmd("~/Public/scripts/awww/awww_autostart.sh")
	-- Notification sound daemon (replaces SwayNC sound scripts)
	hl.exec_cmd("bash ~/Public/scripts/notif-sound/notif-sound.sh")
end)

-- ============================
-- 环境变量
-- ============================
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("GDK_SCALE", "1")
hl.env("QT_FFMPEG_DECODING_HW_DEVICE_TYPES", "none")
hl.env("QS_NO_RELOAD_POPUP", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("GDK_DPI_SCALE", "1") -- GTK X11/XWayland 应用 DPI 缩放

-- ============================
-- XWayland
-- ============================
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

-- ============================
-- hyprland general配置
-- 如果 liquid glass 插件启动后 blur 和 shadow 无效
-- ============================
hl.config({
	decoration = {
		rounding = 20,
		active_opacity = 0.95,
		inactive_opacity = 0.83,

		blur = {
			enabled = true,

			size = 5,
			passes = 2,

			noise = 0.008,
			contrast = 1.03,
			brightness = 0.85,
			vibrancy = 0.42,
			vibrancy_darkness = 0.12,
		},
		shadow = {
			enabled = true,
			color_inactive = "rgba(00000044)",
		},
	},
})

-- Caelestia shell 控件 blur（确保 Hyprland blur 作用于 Caelestia 的 layer surface）
hl.layer_rule({
	match = { namespace = "caelestia-drawers" },
	blur = true,
	ignore_alpha = 0.20,
})
hl.layer_rule({
	match = { namespace = "caelestia-background" },
	blur = true,
	ignore_alpha = 0.20,
})

-- ============================
-- 杂项（vrr, workspace_tracking）
-- ============================
hl.config({
	misc = {
		vrr = 0,
		initial_workspace_tracking = 1,
	},
})

-- ============================
-- 合盖触发 Lid Switch
-- ============================
hl.bind("switch:on:Lid Switch", function()
	hl.exec_cmd("~/Public/scripts/smart_lid/smart_lid.sh close")
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	hl.exec_cmd("~/Public/scripts/smart_lid/smart_lid.sh open")
end, { locked = true })

-- ============================
-- 输入设备细节
-- ============================
hl.config({
	input = {
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			scroll_factor = 1.0,
			tap_to_click = true,
			clickfinger_behavior = true,
		},
	},
})

-- ============================
-- 开机插件启动
-- ============================
hl.plugin.load("/usr/lib/libhyprliquid.so")

-- ============================
-- 液态玻璃插件 https://github.com/zaregototsukai/hyprliquid
-- 启动成功后对系统应用的配置
-- ============================

if hl.plugin.hyprliquid then
	hl.config({
		plugin = {
			hyprliquid = {
				watch_system_color_scheme = true,
				background_sharing = true,
			},
		},
	})

	hl.window_rule({
		name = "kitty",
		match = { class = "kitty" },
		border_size = 0,
		-- no_blur = true,
		no_shadow = true,
		-- ["hyprliquid:tint_color"] = "rgba(0x1a, 0x1b, 0x26, 0.5)",
		-- ["hyprliquid:highlight_style"] = 2,
		-- ["hyprliquid:glass_dispersion"] = true,
		["hyprliquid:effect"] = "liquid_glass",
		["hyprliquid:tint_color"] = "rgba(0, 0, 0, 0.3)",
		["hyprliquid:rounding_lua"] = 32,
		["hyprliquid:highlight_style"] = 4,
		["hyprliquid:glass_dispersion"] = true,
		["hyprliquid:z_radius"] = 32,
		["hyprliquid:glass_thickness"] = 600,
	})

	hl.window_rule({
		name = "floatterm",
		match = { class = "floatterm" },
		border_size = 0,
		-- no_blur = true,
		no_shadow = true,
		float = true,
		center = true,
		size = "1600 1200",
		["hyprliquid:effect"] = "liquid_glass",
		["hyprliquid:tint_color"] = "rgba(0, 0, 0, 0.3)",
		["hyprliquid:rounding_lua"] = 64,
		["hyprliquid:highlight_style"] = 4,
		["hyprliquid:glass_dispersion"] = true,
		["hyprliquid:z_radius"] = 32,
		["hyprliquid:glass_thickness"] = 600,
	})

	hl.window_rule({
		name = "zen-browser",
		match = { class = "zen" },
		["hyprliquid:effect"] = "acrylic_thin",
		["hyprliquid:color_scheme"] = "follow_system",
	})
end
