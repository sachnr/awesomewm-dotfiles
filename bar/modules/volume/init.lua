local wp = require("bar.modules.volume.wireplumber")
local wibox = require("wibox.init")
local gears = require("gears")
local beautiful = require("beautiful")
local helper = require("helper")
local awful = require("awful")
local pallete = require("theme.pallete")
local headphone
local dpi = beautiful.xresources.apply_dpi

local widget = wibox.widget({
    {
        id = "iconbg",
        bg = pallete.background2,
        shape = gears.shape.circle,
        widget = wibox.container.background,
        {
            id = "icon",
            markup = helper.color_text("  ", pallete.brightblue),
            widget = wibox.widget.textbox,
        },
    },
    {
        id = "slider",
        bar_shape = gears.shape.rounded_rect,
        bar_height = dpi(4),
        bar_color = pallete.blue,
        handle_color = pallete.brightblue,
        handle_shape = gears.shape.circle,
        handle_border_color = pallete.brightblue,
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

--      ────────────────────────────────────────────────────────────

local function get_icon(isHeadphone, ismuted, volume)
    if ismuted then
        if isHeadphone then return " 󰟎 " end
        return "  "
    end
    if isHeadphone then
        return " 󰋋 "
    else
        if volume < 50 then
            return "  "
        elseif volume < 100 then
            return "  "
        else
            return "  "
        end
    end
end

local update_widget = function()
    awful.spawn.easy_async_with_shell([[wpctl get-volume @DEFAULT_AUDIO_SINK@]], function(stdout)
        local volume = tonumber(stdout:match("(%d%.%d%d?)")) * 100
        local icon
        if stdout:match("MUTED") then
            icon = get_icon(headphone, true, volume)
        else
            icon = get_icon(headphone, false, volume)
        end
        widget.iconbg.icon:set_markup(helper.color_text(icon, pallete.brightblue))
    end)
end

-- run on startup once
awful.spawn.easy_async_with_shell("pactl list sinks |& grep -E 'Active Port: analog'", function(stdout)
    if stdout:match("lineout") then
        headphone = false
    else
        headphone = true
    end
    awesome.emit_signal("volume::update_slider")
end)

widget.iconbg:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        wp.setMute("sink")
        awesome.emit_signal("volume::update_slider")
        update_widget()
    end
    if button == 3 then
        wp.toggleSink(headphone)
        headphone = not headphone
        awesome.emit_signal("volume::update_slider")
        update_widget()
    end
end)

helper.hover({ widget = widget.iconbg, newbg = pallete.background3, oldbg = pallete.background2 })
helper.hover_hand(widget.slider)

-- Connect to `property::value` to use the value on change
widget.slider:connect_signal("property::value", function(_, value)
    wp.setVolume("sink", value)
    update_widget()
end)

awesome.connect_signal("volume::update_slider", function()
    awful.spawn.easy_async_with_shell([[wpctl get-volume @DEFAULT_AUDIO_SINK@]], function(stdout)
        local volume = tonumber(stdout:match("(%d%.%d%d?)")) * 100
        widget.slider:set_value(volume)
    end)
end)

local volume_boxed = helper.box_widget({
    widget = widget,
    bg_color = pallete.background2,
    margins = dpi(6),
})

return volume_boxed
