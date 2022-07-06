local wibox = require("wibox")
local awful = require("awful")
local watch = awful.widget.watch
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local mat_icon = require("widget.icon-button.icon")
local helpers = require("client.helpers")
local icons = require("icons.flaticons")

-- --------- Setup -----------

local microphone =
    wibox.widget {
    mat_icon(icons.mic, dpi(22)),
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    widget = wibox.container.background,
    bg = beautiful.toggle_button_inactive
}
helpers.add_hover_cursor(microphone, "hand1")

local toggle_action = function()
    -- use 'pamixer --list-sources' to get source id
    awful.spawn.easy_async_with_shell(
        [[
            pamixer --default-source -t --get-mute
		]],
    function(stdout)
        if stdout:match("true") then
            microphone.widget = mat_icon(icons.mic_mute, dpi(22))
            microphone.bg = beautiful.toggle_button_active
        else
            microphone.widget = mat_icon(icons.mic, dpi(22))
            microphone.bg = beautiful.toggle_button_inactive
        end
    end)
end

microphone:buttons(
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

return microphone
