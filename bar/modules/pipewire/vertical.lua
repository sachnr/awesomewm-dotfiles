local wp = require("bar.modules.pipewire.wireplumber")
local awful = require("awful")
local wibox = require("wibox.init")
local gears = require("gears")
local beautiful = require("beautiful")
local helper = require("helper")
local pallete = require("theme.pallete")
local dpi = beautiful.xresources.apply_dpi
require("bar.modules.pipewire.signal")

local widget = wibox.widget({
	{
		id = "iconbg",
		bg = "#00000000",
		shape = gears.shape.circle,
		widget = wibox.container.background,
		{
			id = "icon",
			markup = helper.color_text_icon(" 󰕾  \n", beautiful.accent, "12"),
			widget = wibox.widget.textbox,
		},
	},
	{
		id = "text",
		markup = string.format(
			"<span font='%s bold 10' color='%s'> 0 </span>",
			beautiful.font_alt,
			beautiful.foreground
		),
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	},
	nil,
	height = dpi(40),
	width = dpi(40),
	layout = wibox.layout.align.vertical,
})

widget:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		wp.setMute("sink")
	end
	if button == 3 then
		awful.spawn.easy_async("pavucontrol")
	end
end)

-- Connect to `property::value` to use the value on change
widget:connect_signal("button::press", function(_, _, _, button)
	if button == 4 then
		wp.incVol("5")
	end
	if button == 5 then
		wp.decVol("5")
	end
end)

awesome.connect_signal("volume::update", function(volume, icon)
	widget.iconbg.icon:set_markup(helper.color_text_icon(icon, beautiful.accent, "12"))
	local markup =
		string.format("<span font='%s bold 10' color='%s'> %s </span>", beautiful.font_alt, pallete.foreground, volume)
	widget.text:set_markup(markup)
	wp.setVolume("sink", volume)
end)

local volume_boxed = helper.box_widget({
	widget = widget,
	bg_color = beautiful.module_bg,
	margins = dpi(6),
})

helper.hover({
	widget = volume_boxed:get_children_by_id("box_container")[1],
	newbg = beautiful.module_bg_focused,
	oldbg = beautiful.module_bg,
	hover_cursor = "hand1",
})

return volume_boxed
