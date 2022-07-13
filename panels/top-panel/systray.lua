local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("client.helpers")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")
local dpi = require("beautiful").xresources.apply_dpi

-- =========================================================
-- ====================== Function =========================
-- =========================================================

-- -------- SysTray ----------
local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(20)
systray.forced_height = 20
systray.opacity = 0
systray.visible = false
helpers.add_hover_cursor(systray, "hand1")

local arrow_left = mat_icon(icons.left, dpi(18))
local arrow_right = mat_icon(icons.right, dpi(18))

local widget = wibox.widget{
    arrow_left,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, dpi(12))
    end,
    widget = wibox.container.background,
    bg = beautiful.accent_normal
}
helpers.add_hover_cursor(widget, "hand1")

local update_widget = function()
    if systray.visible then
        widget.widget = arrow_right
    else
        widget.widget = arrow_left
    end
end
    
local toggle = function()
    systray:set_screen (awful.screen.focused())
    systray.visible = not systray.visible
    update_widget()
end



widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
	toggle()
end)))


return wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)),
    wibox.container.margin(systray, dpi(3), dpi(3), dpi(6), dpi(3)),
})