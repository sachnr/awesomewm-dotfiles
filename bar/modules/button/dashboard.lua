local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local pallete = require("theme.pallete")
local helpers = require("helper")
local dashboard = require("bar.modules.button.modules.user")

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
                margins = { bottom = dpi(5), top = dpi(40), left = dpi(5), right = dpi(5) },
            })
        end,
        widget = {
            {
                {
                    -- widget goes here
                    dashboard,
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
    awesome.connect_signal("dashboard::toggle", function(scr)
        if scr == s then s.dashboard.visible = not s.dashboard.visible end
    end)
    ---@diagnostic disable-next-line: undefined-global
    awesome.connect_signal("dashboard::close", function(scr)
        if scr == s then s.dashboard.visible = false end
    end)

    return panel
end

return M
