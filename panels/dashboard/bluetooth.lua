local wibox = require("wibox")
local awful = require("awful")
local watch = awful.widget.watch
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("client.helpers")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")

--- Bluetooth Widget
--- ~~~~~~~~~~~~~~~~

local bluetooth_state = false
local widget = wibox.widget{
    mat_icon(icons.bluetooth, dpi(22)),
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    widget = wibox.container.background,
    bg = beautiful.toggle_button_inactive
}
helpers.add_hover_cursor(widget, "hand1")

local update_widget = function()
	if bluetooth_state then
		widget.bg = beautiful.toggle_button_active
	else
		widget.bg = beautiful.toggle_button_inactive
	end
end

local check_bluetooth_state = function()
	awful.spawn.easy_async_with_shell("rfkill list bluetooth", function(stdout)
		if stdout:match("Soft blocked: yes") then
			bluetooth_state = false
		else
			bluetooth_state = true
		end

		update_widget()
	end)
end

check_bluetooth_state()

local power_on_cmd = [[
	rfkill unblock bluetooth

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Bluetooth Manager',
		title = 'System Notification',
		message = 'Initializing bluetooth device...',
		icon = ']] .. icons.loading .. [['
	})
	"

	# Add a delay here so we can enable the bluetooth
	sleep 1
	
	bluetoothctl power on
]]

local power_off_cmd = [[
	bluetoothctl power off
	rfkill block bluetooth

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Bluetooth Manager',
		title = 'System Notification',
		message = 'The bluetooth device has been disabled.',
		icon = ']] .. icons.bluetooth_off .. [['
	})
	"
]]

local toggle_action = function()
	if bluetooth_state then
		awful.spawn.easy_async_with_shell(power_off_cmd, function(stdout)
			bluetooth_state = false
			update_widget()
		end)
	else
		awful.spawn.easy_async_with_shell(power_on_cmd, function(stdout)
			bluetooth_state = true
			update_widget()
		end)
	end
end

widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
	toggle_action()
end)))

watch("rfkill list bluetooth", 5, function(_, stdout)
	check_bluetooth_state()
	collectgarbage("collect")
end)

return widget
