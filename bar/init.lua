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

local volume = require("bar.modules.volume")
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
local network_speed = require("bar.modules.net_speed_widget")

--      ────────────────────────────────────────────────────────────

---@diagnostic disable-next-line: undefined-global
screen.connect_signal("request::desktop_decoration", function(s)
    awful.tag({ " ", " ", " ", "󰉋 ", "󰵅 ", "󰊠 " }, s, awful.layout.layouts[1])

    s.calendar = require("bar.modules.calendar").setup(s)
    s.dashboard = require("bar.modules.button.dashboard").setup(s)
    s.music_panel = require("bar.modules.mpd.popup").setup(s)

    awful.wallpaper({
        screen = s,
        widget = {
            {
                image = beautiful.wallpaper,
                resize = true,
                widget = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled = false,
            widget = wibox.container.tile,
        },
    })

    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(34),
        widget = {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                layout(s),
                taglist(s),
                tasklist(s),
            },
            { -- Middle widget
                layout = wibox.layout.flex.horizontal,
                mpd,
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                network_speed,
                systray,
                redshift,
                volume,
                time,
                date,
                button,
            },
        },
    })
end)
