local wibox = require("wibox.init")
local helper = require("helper")
local beautiful = require("beautiful")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi

local M = {}

M.setup = function()
	local tray = wibox.widget.systray()
	tray.opacity = 1.0

	local widget = wibox.widget({
		{
			widget = tray,
		},
		left = dpi(6),
		top = dpi(2),
		bottom = dpi(2),
		right = dpi(6),
		widget = wibox.container.margin,
	})

	return helper.create_rounded_widget(widget, dpi(10))
end

return M
