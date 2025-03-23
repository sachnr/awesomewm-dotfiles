local awful = require("awful")
local wibox = require("wibox.init")
local beautiful = require("beautiful")

local M = {}

M.setup = function()
	local widget = wibox.widget.textclock(
		string.format(
			"<span font='%s %s' color='%s'>%%a %%b %%d, %%I:%%M</span>",
			beautiful.font,
			beautiful.font_size,
			beautiful.fg_normal
		)
	)
	return widget
end

return M
