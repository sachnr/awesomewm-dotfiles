local wibox = require("wibox.init")
local helper = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(dpi(20))
systray.forced_height = (dpi(20))

local systray_boxed = helper.box_widget({
    widget = systray,
    bg_color = beautiful.module_bg,
    margins = dpi(6),
})

return systray_boxed
