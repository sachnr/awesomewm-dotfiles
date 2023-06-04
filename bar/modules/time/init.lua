local wibox = require("wibox.init")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local pallete = require("theme.pallete")
local helper = require("helper")

local time = wibox.widget.textclock(
    string.format(
        "<span font='%s 10' color='%s'>   </span><span font='%s bold 10' color='%s'>%%I:%%M %%p </span>",
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

return time_boxed
