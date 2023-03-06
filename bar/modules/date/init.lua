local awful = require("awful")
local wibox = require("wibox.init")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local pallete = require("theme.pallete")
local helper = require("helper")

local date = wibox.widget.textclock(
    string.format(
        "<span font='%s 10' color='%s'>   </span><span font='%s bold 10' color='%s'>%%a, %%b %%d </span>",
        beautiful.icon_font,
        pallete.brightblue,
        beautiful.font_alt,
        pallete.foreground
    )
)

local date_boxed = helper.box_widget({
    widget = date,
    bg_color = beautiful.module_bg,
    margins = dpi(6),
    horizontal_padding = dpi(12),
})

helper.hover({
    widget = date_boxed:get_children_by_id("box_container")[1],
    oldbg = beautiful.module_bg,
    newbg = beautiful.module_bg_focused,
})

date_boxed:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal("calendar::toggle", awful.screen.focused())
    end
end)

return date_boxed
