local awful = require("awful")
local wibox = require("wibox.init")
local pallete = require("theme.pallete")
local helper = require("helper")
local dpi = require("beautiful").xresources.apply_dpi

local widget = wibox.widget({
    {
        id = "icon",
        markup = helper.color_text_icon(" ", pallete.brightblue, "11"),
        widget = wibox.widget.textbox,
    },
    nil,
    nil,
    layout = wibox.layout.align.horizontal,
})

local widget_boxed = helper.box_widget({
    widget = widget,
    bg_color = pallete.background2,
    margins = dpi(6),
})

helper.hover({
    widget = widget_boxed:get_children_by_id("box_container")[1],
    newbg = pallete.background3,
    oldbg = pallete.background2,
})

widget_boxed:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal("dashboard::toggle", awful.screen.focused())
    end
end)

return widget_boxed
