local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helper = require("helper")
local awful = require("awful")
local pallete = require("theme.pallete")

-- Table of layouts to cover with awful.layout.inc, order matters.
---@diagnostic disable-next-line: undefined-global
tag.connect_signal(
    "request::default_layouts",
    function()
        awful.layout.append_default_layouts({
            awful.layout.suit.tile,
            awful.layout.suit.floating,
        })
    end
)

--      ────────────────────────────────────────────────────────────

local layout = require("bar.modules.layoutbox")
local date = require("bar.modules.date")
local time = require("bar.modules.time")
local datetime = require("bar.modules.datetime")
local systray = require("bar.modules.systray")
local taglist = require("bar.modules.taglist")
local tasklist = require("bar.modules.tasklist")
local button = require("bar.modules.button")
local mpd = require("bar.modules.mpd")
local redshift = require("bar.modules.redshift")
local pulseaudio = require("bar.modules.pulseaudio")
-- local pipewire = require("bar.modules.pipewire")
-- local network_speed = require("bar.modules.net_speed_widget").default()

--      ────────────────────────────────────────────────────────────

---@diagnostic disable-next-line: undefined-global
screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({ " ", " ", " ", "󰉋 ", "󰵅 ", "󰊠 " }, s, awful.layout.layouts[1])

    s.calendar = require("bar.modules.calendar").setup(s)
    s.dashboard = require("bar.modules.button.dashboard").setup(s)
    s.music_panel = require("bar.modules.mpd.popup").setup(s)

    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(30),
        widget = {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                layout(s),
                taglist(s),
                tasklist(s),
                -- network_speed,
            },
            { -- Middle widget
                layout = wibox.layout.flex.horizontal,
                mpd,
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                systray,
                redshift,
                pulseaudio,
                -- pipewire,
                time,
                date,
                button,
            },
        },
    })
end)

local gears = require("gears")

---@diagnostic disable-next-line: undefined-global
screen.connect_signal(
    "request::wallpaper",
    function(s)
        awful.wallpaper({
            screen = s,
            bg = "#000000",
            widget = {
                {
                    image = gears.filesystem.get_random_file_from_dir(
                        "/home/sachnr/wallpapers/home",
                        { ".jpg", ".png", ".svg" },
                        true
                    ),
                    resize = true,
                    widget = wibox.widget.imagebox,
                },
                valign = "center",
                halign = "center",
                tiled = false,
                widget = wibox.container.tile,
            },
        })
    end
)

-- **Somewhere else** in the code, **not** in the request::wallpaper handler.
gears.timer({
    timeout = 300,
    autostart = true,
    callback = function()
        ---@diagnostic disable-next-line: undefined-global
        for s in screen do
            s:emit_signal("request::wallpaper")
        end
    end,
})
