local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local pallete = require("theme.pallete")
local mpc = require("bar.modules.mpd.mpc_cli")

local song_title = wibox.widget({
    widget = wibox.widget.textbox,
    font = beautiful.font_alt .. " Bold 10",
    valign = "center",
})

local artist = wibox.widget({
    widget = wibox.widget.textbox,
    font = beautiful.font_alt .. " Bold 9",
    valign = "center",
})

local cover_art = wibox.widget({
    {
        {
            id = "cover_art",
            image = beautiful.cover_art,
            resize = true,
            clip_shape = helpers.rounded_rect(dpi(8)),
            halign = "center",
            valign = "center",
            widget = wibox.widget.imagebox,
        },
        border_width = dpi(1),
        border_color = pallete.border,
        shape = helpers.rounded_rect(dpi(8)),
        widget = wibox.container.background,
    },
    strategy = "exact",
    height = dpi(120),
    width = dpi(120),
    widget = wibox.container.constraint,
})

local tasks = {
    prev = function() return mpc.prev() end,
    play = function() return mpc.toggle() end,
    pause = function() return mpc.toggle() end,
    next = function() return mpc.next() end,
}

local icons = {
    prev = "󰒮",
    play = "󰐊",
    pause = "󰏤",
    next = "󰒭",
}

local music_controls = {}

for key, value in pairs(icons) do
    local widget = wibox.widget({
        {
            id = "icon",
            font = beautiful.icon_font .. " Bold 10",
            markup = string.format('<span foreground="%s"> %s </span>', pallete.foreground, value),
            widget = wibox.widget.textbox,
        },
        nil,
        nil,
        forced_height = dpi(40),
        forced_width = dpi(30),
        layout = wibox.layout.align.horizontal,
    })

    widget:connect_signal("mouse::enter", function()
        widget.icon:set_markup(string.format('<span foreground="%s"> %s </span>', beautiful.accent, value))
        ---@diagnostic disable-next-line: undefined-global
        local w = mouse.current_wibox
        if w then w.cursor = "hand1" end
    end)
    widget:connect_signal("mouse::leave", function()
        widget.icon:set_markup(string.format('<span foreground="%s"> %s </span>', pallete.foreground, value))
        ---@diagnostic disable-next-line: undefined-global
        local w = mouse.current_wibox
        if w then w.cursor = "left_ptr" end
    end)

    music_controls[key] = helpers.box_widget({
        widget = widget,
        bg_color = beautiful.module_bg,
        margins = dpi(2),
        shape = gears.shape.circle,
        horizontal_padding = dpi(0),
    })

    music_controls[key]:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then tasks[key]() end
    end)
end

local widget = wibox.widget({
    {
        cover_art,
        {
            nil,
            {
                {
                    widget = wibox.container.margin,
                    song_title,
                },
                {
                    widget = wibox.container.margin,
                    artist,
                },
                {
                    nil,
                    nil,
                    {
                        helpers.padding_h(dpi(4)),
                        music_controls.prev,
                        music_controls.play,
                        music_controls.pause,
                        music_controls.next,
                        spacing = dpi(10),
                        layout = wibox.layout.fixed.horizontal,
                    },
                    expand = "none",
                    layout = wibox.layout.flex.horizontal,
                },
                forced_width = dpi(160),
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(8),
            },
            layout = wibox.layout.align.vertical,
            expand = "none",
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(15),
    },
    layout = wibox.layout.align.vertical,
})

local widget_boxed = helpers.box_widget({
    widget = widget,
    bg_color = beautiful.module_bg,
    shape = helpers.rounded_rect(dpi(8)),
    margin = dpi(6),
    horizontal_padding = dpi(0),
})

awesome.connect_signal("mpd::status", function(t)
    setmetatable(t, { __index = { title = "offline", artist = "" } })
    local artist_name = string.format("<span foreground='%s'> %s </span> ", beautiful.accent, t.artist)
    local title = string.format("<span foreground='%s'> %s </span> ", pallete.foreground, t.title)

    local status = function()
        if t.status:match("playing") then return true end
        return false
    end

    if status() then
        music_controls.play.visible = false
        music_controls.pause.visible = true
    else
        music_controls.play.visible = true
        music_controls.pause.visible = false
    end

    artist:set_markup(artist_name)
    song_title:set_markup(title)
end)

awesome.connect_signal("mpd::cover_art", function(image) cover_art:get_children_by_id("cover_art")[1].image = image end)

return widget_boxed
