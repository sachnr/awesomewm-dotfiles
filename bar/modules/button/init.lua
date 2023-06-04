local awful = require("awful")
local wibox = require("wibox.init")
local pallete = require("theme.pallete")
local helper = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local widget = wibox.widget({
    {
        id = "icon",
        markup = helper.color_text_icon(" ", beautiful.accent, "11"),
        widget = wibox.widget.textbox,
    },
    nil,
    nil,
    layout = wibox.layout.align.horizontal,
})

local widget_boxed = helper.box_widget({
    widget = widget,
    bg_color = beautiful.module_bg,
    margins = dpi(6),
})

helper.hover({
    widget = widget_boxed:get_children_by_id("box_container")[1],
    oldbg = beautiful.module_bg,
    newbg = beautiful.module_bg_focused,
})

widget_boxed:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal("dashboard::toggle", awful.screen.focused())
    end
end)

return widget_boxed
