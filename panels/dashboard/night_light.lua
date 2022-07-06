local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("client.helpers")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")

-- --------- Setup -----------

local blue_light_state = false
local bluelight = wibox.widget{
    mat_icon(icons.reading, dpi(22)),
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    widget = wibox.container.background,
    bg = beautiful.toggle_button_inactive
}
helpers.add_hover_cursor(bluelight, "hand1")

local update_widget = function()
    if blue_light_state then
        bluelight.bg = beautiful.toggle_button_active
    else
        bluelight.bg = beautiful.toggle_button_inactive
    end
end

local kill_state = function()
    awful.spawn.easy_async_with_shell(
        [[
		redshift -x
		kill -9 $(pgrep redshift)
		]],
        function(stdout)
            stdout = tonumber(stdout)
            if stdout then
                blue_light_state = false
                update_widget()
            end
        end
    )
end
kill_state()

local toggle_action = function()
    awful.spawn.easy_async_with_shell(
        [[
		if [ ! -z $(pgrep redshift) ];
		then
			redshift -x && pkill redshift && killall redshift
			echo 'OFF'
		else
			redshift -l 0:0 -t 4500:4500 -r &>/dev/null &
			echo 'ON'
		fi
		]],
        function(stdout)
            if stdout:match("ON") then
                blue_light_state = true
            else
                blue_light_state = false
            end
            update_widget()
        end
    )
end

bluelight:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            nil,
            function()
                toggle_action()
            end
        )
    )
)

return bluelight
