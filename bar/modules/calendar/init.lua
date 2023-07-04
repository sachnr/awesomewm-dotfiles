local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local pallete = require("theme.pallete")
local helpers = require("helper")
local cal_widget = helpers.box_widget({
    widget = require("bar.modules.calendar.calender_widget"),
    bg_color = pallete.background,
    shape = helpers.rounded_rect(dpi(8)),
    margin = dpi(6),
})
local network_speed = require("bar.modules.net_speed_widget").setup({
    forced_height = dpi(30),
    horizontal_padding = 0
})

local M = {}

M.setup = function(s)
    local panel = awful.popup({
        ontop = true,
        screen = s,
        visible = false,
        type = "dock",
        bg = pallete.black,
        fg = pallete.foreground,
        shape = helpers.rounded_rect(dpi(4)),
        placement = function(w)
            awful.placement.top_right(w, {
                margins = { bottom = dpi(5), top = dpi(40), left = dpi(5), right = dpi(40) },
            })
        end,
        widget = {
            {
                {
                    -- widget goes here
                    cal_widget,
                    network_speed,
                    spacing = dpi(20),
                    layout = wibox.layout.fixed.vertical,
                    widget = wibox.container.margin,
                },
                margins = dpi(16),
                widget = wibox.container.margin,
            },
            shape = helpers.rounded_rect(dpi(12)),
            bg = pallete.black,
            widget = wibox.container.background,
        },
        layout = wibox.layout.align.vertical,
    })

    panel.opened = false
    ---@diagnostic disable-next-line: undefined-global
    awesome.connect_signal("calendar::toggle", function(scr)
        if scr == s then s.calendar.visible = not s.calendar.visible end
    end)
    ---@diagnostic disable-next-line: undefined-global
    awesome.connect_signal("calendar::close", function(scr)
        if scr == s then s.calendar.visible = false end
    end)

    return panel
end

return M
