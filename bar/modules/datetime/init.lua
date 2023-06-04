local wibox = require("wibox.init")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local pallete = require("theme.pallete")
local helper = require("helper")
local awful = require("awful")

local time = wibox.widget.textclock(
    string.format(
        "<span font='%s 10' color='%s'>   </span><span font='%s bold 10' color='%s'>%%a, %%b %%d </span><span font='%s 10' color='%s'>  </span><span font='%s bold 10' color='%s'> %%I:%%M %%p </span>",
        beautiful.icon_font,
        beautiful.accent,
        beautiful.font_alt,
        pallete.foreground,
        beautiful.icon_font,
        beautiful.accent,
        beautiful.font_alt,
        pallete.foreground
    )
)

local time_boxed = helper.box_widget({
    widget = time,
    bg_color = beautiful.module_bg,
    margins = dpi(6),
    horizontal_padding = dpi(12),
})

helper.hover({
    widget = time_boxed:get_children_by_id("box_container")[1],
    oldbg = beautiful.module_bg,
    newbg = beautiful.module_bg_focused,
})

time_boxed:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal("calendar::toggle", awful.screen.focused())
    end
end)

return time_boxed
