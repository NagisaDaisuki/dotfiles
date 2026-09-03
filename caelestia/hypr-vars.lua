return {
	------------------
	---- APPS ----
	------------------
	terminal = "kitty",
	fileExplorer = "thunar",

	------------------
	---- CURSOR ----
	------------------
	cursorTheme = "Marisa-Kirisame",
	cursorSize = 24,

	------------------
	---- TOUCHPAD ----
	------------------
	touchpadDisableTyping = true,
	touchpadScrollFactor = 1.0,

	------------------
	---- BLUR (Liquid Glass style) ----
	------------------
	blurSize = 2,
	blurPasses = 1,
	blurXray = true,

	------------------
	---- SHADOW ----
	------------------
	shadowRange = 22,
	shadowRenderPower = 3,

	------------------
	---- WINDOW ----
	------------------
	windowOpacity = 0.96,
	windowRounding = 10,
	windowBorderSize = 3,

	------------------
	---- KEYBINDS (old habits) ----
	------------------

	-- Apps
	kbTerminal = "SUPER + Q",
	kbCloseWindow = "SUPER + C",
	kbToggleWindowFloating = "SUPER + V",
	kbLauncher = "SUPER + R",
	kbSession = "SUPER + M",

	-- Move displaced defaults
	kbEditor = "SUPER + SHIFT + E",
	kbTodoWs = "SUPER + SHIFT + R",
	kbClipboard = "SUPER + SHIFT + V",
	kbMusicWs = "SUPER + SHIFT + M",
	kbCommunicationWs = "SUPER + SHIFT + D",

	-- Repurpose SUPER+J for show panels (old "restart panel")
	kbShowPanels = "SUPER + J",

	-- Screenshot: old habits
	kbScreenshot = "SUPER + SHIFT + F",
	kbScreenshotRegion = "SUPER + SHIFT + S",
	kbScreenshotFreeze = "SUPER + SHIFT + ALT + S",
}
