local wp = require("bar.modules.pipewire.wireplumber")
local awful = require("awful")
local wibox = require("wibox.init")
local gears = require("gears")
local beautiful = require("beautiful")
local helper = require("helper")
local pallete = require("theme.pallete")
local dpi = beautiful.xresources.apply_dpi
require("bar.modules.pipewire.signal")

local widget = wibox.widget({
    {
        id = "iconbg",
        bg = beautiful.module_bg,
        shape = gears.shape.circle,
        widget = wibox.container.background,
        {
            id = "icon",
            markup = helper.color_text_icon(" 󰕾  ", beautiful.accent, "10"),
            widget = wibox.widget.textbox,
        },
    },
    {
        id = "slider",
        bar_shape = gears.shape.rounded_rect,
        bar_height = dpi(4),
        bar_color = pallete.blue,
        handle_color = beautiful.accent,
        handle_shape = gears.shape.circle,
        handle_border_color = beautiful.accent,
        handle_border_width = dpi(1),
        value = 1,
        maximum = 150,
        minimum = 0,
        widget = wibox.widget.slider,
    },
    nil,
    forced_height = dpi(24),
    forced_width = dpi(96),
    layout = wibox.layout.align.horizontal,
})

-- gradient pattern
local vol_gradient = {
    type = "linear",
    from = { 0, 0 },
    to = { 96, 0 },
    stops = {
        { 0, pallete.brightblack },
        { 1, pallete.red },
    },
}

-- delay to reduce no of requests
local slider_timer = gears.timer({
    timeout = 0.2,
    single_shot = true,
    callback = function() wp.setVolume("sink", widget.slider.value) end,
})
-- Connect to `property::value` to use the value on change
widget.slider:connect_signal("property::value", function() slider_timer:again() end)

helper.hover({ widget = widget.iconbg, newbg = beautiful.module_bg_focused, oldbg = beautiful.module_bg })

helper.hover_hand(widget.slider)

widget.iconbg:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then wp.setMute("sink") end
    if button == 3 then awful.spawn.easy_async("pavucontrol") end
end)

-- Connect to `property::value` to use the value on change
widget.slider:connect_signal("button::press", function(_, _, _, button)
    if button == 4 then wp.incVol("5") end
    if button == 5 then wp.decVol("5") end
end)

awesome.connect_signal("volume::update", function(volume, icon)
    widget.iconbg.icon:set_markup(helper.color_text_icon(icon, beautiful.accent, "10"))
    widget.slider:set_value(volume)
    if volume > 100 then
        widget.slider.bar_color = vol_gradient
    else
        widget.slider.bar_color = pallete.brightblack
    end
end)

local volume_boxed = helper.box_widget({
    widget = widget,
    bg_color = beautiful.module_bg,
    margins = dpi(6),
})

return volume_boxed
