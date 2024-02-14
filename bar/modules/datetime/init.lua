local wibox = require("wibox.init")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helper = require("helper")
local awful = require("awful")
local pallete = require("theme.pallete")

local datetime = {}

datetime.setup = function(style)
	local time
	if style == "vertical" then
		time = wibox.widget.textclock(
			string.format(
				"<span font='%s bold 14' color='%s'>%%H\n%%M</span>\n\n<span font='%s bold 10' color='%s'> %%b\n %%d</span>",
				beautiful.font_alt,
				beautiful.accent,
				beautiful.font_alt,
				beautiful.fg_normal
			)
		)
	else
		time = wibox.widget.textclock(
			string.format(
				"<span font='%s 11' color='%s'>  </span><span font='%s bold 10.2' color='%s'> %%d %%b %%I:%%M </span>",
				beautiful.icon_font,
				beautiful.accent,
				beautiful.font_alt,
				pallete.foreground
			)
		)
	end

	local time_boxed = helper.box_widget({
		widget = time,
		bg_color = beautiful.module_bg,
		margins = dpi(6),
		horizontal_padding = dpi(12),
	})

	helper.hover({
		widget = time_boxed:get_children_by_id("box_container")[1],
		oldbg = beautiful.module_bg,
		newbg = beautiful.module_bg_focused,
	})

	time_boxed:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			---@diagnostic disable-next-line: undefined-global
			awesome.emit_signal("calendar::toggle", awful.screen.focused())
		end
	end)

	return time_boxed
end

return datetime
