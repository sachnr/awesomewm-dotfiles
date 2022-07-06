local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("client.helpers")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")

--- Wifi Widget
--- ~~~~~~~~~~~~~~~~

local wifi_state = false
local widget = wibox.widget{
    mat_icon(icons.wifi, dpi(22)),
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    widget = wibox.container.background,
    bg = beautiful.toggle_button_inactive
}
helpers.add_hover_cursor(widget, "hand1")

local update_widget = function()
	if wifi_state then
		widget.bg = beautiful.toggle_button_active
	else
		widget.bg = beautiful.toggle_button_inactive
	end
end

local check_wifi_state = function()
	awful.spawn.easy_async_with_shell("nmcli radio wifi", function(stdout)
		if stdout:match("enabled") then
			wifi_state = true
		else
			wifi_state = false
		end

		update_widget()
	end)
end

check_wifi_state()

local power_on_cmd = [[
    rfkill block wifi
	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Wifi Manager',
		title = 'System Notification',
		message = 'Initializing Wifi device...',
		icon = ']] .. icons.loading .. [['
	})
	"

	# Add a delay here so we can enable the Wifi
	sleep 1
	
	nmcli radio wifi on
]]

local power_off_cmd = [[
	nmcli radio wifi off
	rfkill block wifi

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Wifi Manager',
		title = 'System Notification',
		message = 'The Wifi device has been disabled.',
		icon = ']] .. icons.wifi_off .. [['
	})
	"
]]

local toggle_action = function()
	if wifi_state then
		awful.spawn.easy_async_with_shell(power_off_cmd, function(stdout)
			wifi_state = false
			update_widget()
		end)
	else
		awful.spawn.easy_async_with_shell(power_on_cmd, function(stdout)
			wifi_state = true
			update_widget()
		end)
	end
end

widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
	toggle_action()
end)))

return widget
