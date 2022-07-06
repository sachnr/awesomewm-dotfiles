local wibox = require("wibox")
local awful = require("awful")
local watch = awful.widget.watch
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("client.helpers")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. "panels/dashboard/"

--- Bluetooth Widget
--- ~~~~~~~~~~~~~~~~

local airplane_mode_state = false

local widget = 
wibox.widget{
    mat_icon(icons.airplane_mode, dpi(22)),
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    widget = wibox.container.background,
    bg = beautiful.toggle_button_inactive
}
helpers.add_hover_cursor(widget, "hand1")

local update_widget = function()
	if airplane_mode_state then
		widget.bg = beautiful.toggle_button_active
	else
		widget.bg = beautiful.toggle_button_inactive
	end
end

local check_airplane_mode_state = function()
	local cmd = "cat " .. widget_dir .. "airplane_mode_status"

	awful.spawn.easy_async_with_shell(cmd, function(stdout)
		local status = stdout

		if status:match("true") then
			airplane_mode_state = true
		elseif status:match("false") then
			airplane_mode_state = false
		else
			airplane_mode_state = false
			awful.spawn.easy_async_with_shell('echo "false" > ' .. widget_dir .. "airplane_mode_status", function(stdout) end)
		end
		update_widget()
	end)
end

check_airplane_mode_state()

local airplane_off_cmd = [[
	
	rfkill unblock wlan

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Network Manager',
		title = 'Airplane mode disabled!',
		message = 'Initializing network devices',
		icon = ']] .. icons.airplane_mode_off .. [['
	})
	"
	]] .. "echo false > " .. widget_dir .. "airplane_mode_status" .. [[
]]

local airplane_on_cmd = [[

	rfkill block wlan

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Network Manager',
		title = 'Airplane mode enabled!',
		message = 'Disabling radio devices',
		icon = ']] .. icons.airplane_mode .. [['
	})
	"
	]] .. "echo true > " .. widget_dir .. "airplane_mode_status" .. [[
]]

local toggle_action = function()
	if airplane_mode_state then
		awful.spawn.easy_async_with_shell(airplane_off_cmd, function(stdout)
			airplane_mode_state = false
			update_widget()
		end)
	else
		awful.spawn.easy_async_with_shell(airplane_on_cmd, function(stdout)
			airplane_mode_state = true
			update_widget()
		end)
	end
end

widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
	toggle_action()
end)))

gears.timer({
	timeout = 5,
	autostart = true,
	callback = function()
		check_airplane_mode_state()
	end,
})

return widget
