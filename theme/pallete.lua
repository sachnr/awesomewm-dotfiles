local beautiful = require("beautiful")
local colors = beautiful.xresources.get_current_theme()

local function hexToRGBA(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)) / 255,
		tonumber("0x" .. hex:sub(3, 4)) / 255,
		tonumber("0x" .. hex:sub(5, 6)) / 255,
		1
end

local function RGBAToHex(r, g, b, a)
	return string.format("#%02X%02X%02X", r * 255, g * 255, b * 255)
end

local function lightenColor(hex, percent)
	local r, g, b, a = hexToRGBA(hex)
	r = r + (1 - r) * percent
	g = g + (1 - g) * percent
	b = b + (1 - b) * percent
	return RGBAToHex(r, g, b, a)
end

local pallete = {
	background = colors.background,
	background2 = lightenColor(colors.background, 3),
	background3 = lightenColor(colors.background, 6),
	foreground = colors.foreground,
	selection = colors.selection,
	border = colors.color10,
	accent = colors.color10,
	black = colors.color0,
	red = colors.color1,
	green = colors.color2,
	yellow = colors.color3,
	blue = colors.color4,
	purple = colors.color5,
	aqua = colors.color6,
	gray = colors.color7,
	brightblack = colors.color8,
	brightred = colors.color9,
	brightgreen = colors.color10,
	brightyellow = colors.color11,
	brightblue = colors.color12,
	brightpurple = colors.color13,
	brightaqua = colors.color14,
	brightgray = colors.color15,
}

return pallete
-- return require("theme.colorschemes.kanagawa")
