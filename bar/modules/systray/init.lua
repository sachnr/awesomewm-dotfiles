local wibox = require("wibox.init")
local helper = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local function systray(style)
	local tray = wibox.widget.systray()

	if style == "vertical" then
		tray:set_horizontal(false)
	else
		tray.forced_height = dpi(20)
	end
	tray:set_base_size(dpi(20))

	local systray_boxed = helper.box_widget({
		widget = tray,
		bg_color = beautiful.module_bg,
		margins = dpi(6),
	})

	return systray_boxed
end

return systray
