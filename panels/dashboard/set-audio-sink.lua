local wibox = require("wibox")
local awful = require("awful")
local watch = awful.widget.watch
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("client.helpers")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")

local headphone_state = false

local widgeth = mat_icon(icons.headphone, dpi(22))
local widgetv =mat_icon(icons.volume, dpi(22))

local widget = wibox.widget{
    widgetv,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    widget = wibox.container.background,
    bg = beautiful.toggle_button_inactive
}
helpers.add_hover_cursor(widget, "hand1")

local update_widget = function()
	if headphone_state then
		widget.widget = widgeth
	else
		widget.widget = widgetv
	end
end

local check_sound_state = function()
	awful.spawn.easy_async_with_shell("pacmd list-sinks | grep 'active port:' | awk '{print $3}'", function(stdout)
		if stdout:match("<analog-output-lineout>") then
			headphone_state = false
        elseif stdout:match("<analog-output-headphones>") then
			headphone_state = true
		end
		update_widget()
	end)
end
check_sound_state()

local power_on_cmd = [[
    pactl set-sink-port alsa_output.pci-0000_00_1f.3.analog-stereo analog-output-headphones
	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Sound Manager',
		title = 'System Notification',
		message = 'Headphones Turned On',
		icon = ']] .. icons.headphone .. [['
	})
	"
]]

local power_off_cmd = [[
    pactl set-sink-port alsa_output.pci-0000_00_1f.3.analog-stereo analog-output-lineout
	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Sound Manager',
		title = 'System Notification',
		message = 'Speakers Turned On',
		icon = ']] .. icons.volume .. [['
	})
	"
]]

local toggle_action = function()
	if headphone_state then
		awful.spawn.easy_async_with_shell(power_off_cmd, function(stdout)
			headphone_state = false
			update_widget()
		end)
	else
		awful.spawn.easy_async_with_shell(power_on_cmd, function(stdout)
			headphone_state = true
			update_widget()
		end)
	end
end

widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
	toggle_action()
end)))

return widget