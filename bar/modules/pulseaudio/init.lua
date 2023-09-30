-- modified from https://github.com/stefano-m/awesome-pulseaudio_widget/blob/master/pulseaudio_widget.lua

local string = string

local awful = require("awful")
local gears = require("gears")

local wibox = require("wibox")
local naughty = require("naughty")
local helper = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local pallete = require("theme.pallete")

local pulse = require("pulseaudio_dbus")

local function load_icon(icon)
    icon = helper.color_text_icon(icon, beautiful.accent, "10")
    return icon
end

local icon = {
    mute = " 󰝟  ",
    low = " 󰕿 ",
    medium = " 󰖀  ",
    high = " 󰕾  ",
    headphone = " 󰋋  ",
    headphone_mute = " 󰟎  ",
}

local gradient_pattern = {
    type = "linear",
    from = { 0, 0 },
    to = { 96, 0 },
    stops = {
        { 0, pallete.brightblack },
        { 1, pallete.red },
    },
}

local widget = wibox.widget({
    {
        {
            {
                helper.padding_h(dpi(6)),
                {
                    {
                        id = "iconbg",
                        bg = beautiful.module_bg,
                        shape = gears.shape.circle,
                        widget = wibox.container.background,
                        {
                            id = "icon",
                            markup = load_icon(icon.high),
                            widget = wibox.widget.textbox,
                        },
                    },
                    {
                        id = "slider",
                        bar_shape = gears.shape.rounded_rect,
                        bar_height = dpi(4),
                        bar_color = beautiful.module_bg,
                        handle_color = beautiful.accent,
                        handle_shape = gears.shape.circle,
                        handle_border_color = beautiful.accent,
                        handle_border_width = dpi(1),
                        value = 1,
                        maximum = 150,
                        minimum = 0,
                        widget = wibox.widget.slider,
                    },
                    forced_height = dpi(24),
                    forced_width = dpi(96),
                    margins = dpi(6),
                    layout = wibox.layout.align.horizontal,
                },
                helper.padding_h(dpi(6)),
                layout = wibox.layout.align.horizontal,
                expand = "none",
            },
            layout = wibox.layout.align.horizontal,
            expand = "none",
        },
        shape = helper.rounded_rect(dpi(4)),
        bg = beautiful.module_bg,
        widget = wibox.container.background,
    },
    margins = dpi(6),
    color = "#00000000",
    widget = wibox.container.margin,
})

-- add hover effect and tooltip
helper.hover({
    widget = widget:get_children_by_id("iconbg")[1],
    newbg = beautiful.module_bg_focused,
    oldbg = beautiful.module_bg,
})
helper.hover_hand(widget:get_children_by_id("slider")[1])
widget:get_children_by_id("slider")[1].tooltip = awful.tooltip({ objects = { widget } })

-- slider
local slider_timer = gears.timer({
    timeout = 0.2,
    single_shot = true,
    callback = function()
        local v = widget:get_children_by_id("slider")[1].value
        widget.set_volume({ v })
    end,
})
widget:get_children_by_id("slider")[1]:connect_signal("property::value", function() slider_timer:again() end)

function widget:update_appearance(v)
    local i, msg, gradient

    if v == "Muted" then
        msg = v
        i = load_icon(icon.mute)
        gradient = pallete.brightblack
        self:get_children_by_id("slider")[1]:set_value(0)
    else
        v = v == "Unmuted" and self.sink:get_volume_percent()[1] or tonumber(v)
        msg = string.format("%d%%", v)
        if v < 50 then
            gradient = pallete.brightblack
            i = load_icon(icon.low)
        elseif v < 100 then
            gradient = pallete.brightblack
            i = load_icon(icon.medium)
        else
            gradient = gradient_pattern
            i = load_icon(icon.high)
        end
        self:get_children_by_id("slider")[1]:set_value(v)
    end

    self:get_children_by_id("icon")[1]:set_markup(i)
    self:get_children_by_id("slider")[1].tooltip:set_text(msg)
    self:get_children_by_id("slider")[1].bar_color = gradient
end

function widget:update_sink(object_path) self.sink = pulse.get_device(self.connection, object_path) end

function widget:update_sources(sources)
    for _, source_path in ipairs(sources) do
        local s = pulse.get_device(self.connection, source_path)
        if s.Name and not s.Name:match("%.monitor$") then
            self.source = s
            break
        else
            self.source = nil
        end
    end
end

function widget.volume_up()
    if not widget.sink:is_muted() then widget.sink:volume_up() end
end

function widget.volume_down()
    if not widget.sink:is_muted() then widget.sink:volume_down() end
end

function widget.toggle_muted() widget.sink:toggle_muted() end

function widget.volume_up_mic()
    if widget.source and not widget.source:is_muted() then widget.source:volume_up() end
end

function widget.volume_down_mic()
    if widget.source and not widget.source:is_muted() then widget.source:volume_down() end
end

function widget.toggle_muted_mic()
    if widget.source then widget.source:toggle_muted() end
end

function widget.set_volume(v)
    if not widget.sink:is_muted() then widget.sink:set_volume_percent(v) end
end

widget:get_children_by_id("iconbg")[1]:buttons(
    gears.table.join(
        awful.button({}, 1, widget.toggle_muted),
        awful.button({}, 3, function() awful.spawn(widget.mixer) end)
    )
)

widget
    :get_children_by_id("slider")[1]
    :buttons(gears.table.join(awful.button({}, 4, widget.volume_up), awful.button({}, 5, widget.volume_down)))

function widget:connect_device(device)
    if not device then return end

    if device.signals.VolumeUpdated then
        device:connect_signal(function(this, volume)
            -- FIXME: BaseVolume for sources (i.e. microphones) won't give the correct percentage
            local v = math.ceil(tonumber(volume[1]) / this.BaseVolume * 100)
            if this.object_path == self.sink.object_path then self:update_appearance(v) end
        end, "VolumeUpdated")
    end

    if device.signals.MuteUpdated then
        device:connect_signal(function(this, is_mute)
            local m = is_mute and "Muted" or "Unmuted"
            if this.object_path == self.sink.object_path then self:update_appearance(m) end
        end, "MuteUpdated")
    end
end

function widget:init()
    local status, address = pcall(pulse.get_address)
    if not status then
        naughty.notify({
            title = "Error while loading the PulseAudio widget",
            text = address,
            preset = naughty.config.presets.critical,
        })
        return self
    end

    self.mixer = "pavucontrol"
    self.notification_timeout_seconds = 1

    self.connection = pulse.get_connection(address)
    self.core = pulse.get_core(self.connection)

    -- listen on ALL objects as sinks and sources may change
    self.core:ListenForSignal("org.PulseAudio.Core1.Device.VolumeUpdated", {})
    self.core:ListenForSignal("org.PulseAudio.Core1.Device.MuteUpdated", {})

    self.core:ListenForSignal("org.PulseAudio.Core1.NewSink", { self.core.object_path })
    self.core:connect_signal(function(_, newsink)
        self:update_sink(newsink)
        self:connect_device(self.sink)
        local volume = self.sink:is_muted() and "Muted" or self.sink:get_volume_percent()[1]
        self:update_appearance(volume)
    end, "NewSink")

    -- self.core:ListenForSignal("org.PulseAudio.Core1.NewSource", { self.core.object_path })
    -- self.core:connect_signal(function(_, newsource)
    --     self:update_sources({ newsource })
    --     self:connect_device(self.source)
    -- end, "NewSource")
    --
    -- self:update_sources(self.core:get_sources())
    -- self:connect_device(self.source)

    local sink_path = assert(self.core:get_sinks()[1], "No sinks found")
    self:update_sink(sink_path)
    self:connect_device(self.sink)

    local volume = self.sink:is_muted() and "Muted" or self.sink:get_volume_percent()[1]
    self:update_appearance(volume)

    self.__index = self

    return self
end

return widget:init()
