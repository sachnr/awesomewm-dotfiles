local awful = require("awful")
local wibox = require("wibox.init")
local pallete = require("theme.pallete")
local helper = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local redshift_on = false

local widget = wibox.widget({
    {
        id = "text",
        font = beautiful.icon_font .. " Bold 10",
        markup = string.format('<span foreground="%s"> 󱩌 </span>', pallete.brightblue),
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

helper.hover_hand(widget_boxed)

widget_boxed:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then awesome.emit_signal("redshift::toggle") end
end)

awesome.connect_signal("redshift::toggle", function()
    if redshift_on then
        awesome.emit_signal("redshift::off")
    else
        awful.spawn.easy_async("redshift -l 0:0 -t 3600:3600")
        widget_boxed:get_children_by_id("box_container")[1]:set_bg(beautiful.module_bg_focused)
        widget
            :get_children_by_id("text")[1]
            :set_markup(string.format('<span foreground="%s"> 󱩌 </span>', pallete.brightred))
        redshift_on = not redshift_on
    end
end)

awesome.connect_signal("redshift::off", function()
    awful.spawn.easy_async_with_shell(
        [[
            redshift -x
            kill -9 $(pgrep redshift)
        ]],
        function()
            redshift_on = not redshift_on
            widget_boxed:get_children_by_id("box_container")[1]:set_bg(beautiful.module_bg)
            widget
                :get_children_by_id("text")[1]
                :set_markup(string.format('<span foreground="%s"> 󱩌 </span>', pallete.brightblue))
        end
    )
end)

return widget_boxed
