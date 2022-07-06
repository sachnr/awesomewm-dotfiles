-- ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗
-- ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗
-- ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║
-- ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║
-- ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝
-- ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local mat_icon_button_rect = require("widget.icon-button.icon-button-rect")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")

local helpers = require("client.helpers")

PANEL_VISIBLE = false

-- define module table
local dashboard = {}

-- =========================================================
-- ===================== icons init ========================
-- =========================================================

-- --- Creating Buttons ------
local places_icon_dir = gears.filesystem.get_configuration_dir() .. "icons/places/"
local home = mat_icon_button_rect(mat_icon(places_icon_dir .. "home.svg", dpi(22)))
local Documents = mat_icon_button_rect(mat_icon(places_icon_dir .. "documents.svg", dpi(22)))
local Downloads = mat_icon_button_rect(mat_icon(places_icon_dir .. "downloads.svg", dpi(22)))
local Pictures = mat_icon_button_rect(mat_icon(places_icon_dir .. "pictures.svg", dpi(22)))
local Music = mat_icon_button_rect(mat_icon(places_icon_dir .. "music.svg", dpi(22)))
local Videos = mat_icon_button_rect(mat_icon(places_icon_dir .. "videos.svg", dpi(22)))
local Root = mat_icon_button_rect(mat_icon(places_icon_dir .. "root.svg", dpi(22)))
local Trash = mat_icon_button_rect(mat_icon(places_icon_dir .. "trash.svg", dpi(22)))
local terminal = mat_icon_button_rect(mat_icon(icons.terminal, dpi(18)))
local browser = mat_icon_button_rect(mat_icon(icons.browser, dpi(18)))
local editor = mat_icon_button_rect(mat_icon(icons.code, dpi(18)))
local hotkeys = mat_icon_button_rect(mat_icon(icons.key, dpi(18)))
helpers.bmaker(home, apps.filebrowser .. " " .. "")
helpers.bmaker(Documents, apps.filebrowser .. " " .. "Documents")
helpers.bmaker(Downloads, apps.filebrowser .. " " .. "Downloads")
helpers.bmaker(Pictures, apps.filebrowser .. " " .. "Pictures")
helpers.bmaker(Music, apps.filebrowser .. " " .. "Music")
helpers.bmaker(Videos, apps.filebrowser .. " " .. "Videos")
helpers.bmaker(Root, apps.filebrowser .. " " .. "/")
helpers.bmaker(Trash, apps.filebrowser .. " " .. "/home/" .. os.getenv("USER") .. "/.local/share/Trash/files/")
helpers.bmaker(terminal, apps.terminal)
helpers.bmaker(browser, apps.browser)
helpers.bmaker(editor, apps.editor)
helpers.bmaker(hotkeys, "feh " .. gears.filesystem.get_configuration_dir() .. "configs/hotkeys.png")

--  Placing Buttons into Containers

--apps
local apps_widget =
    wibox.widget {
    {
        terminal,
        browser,
        editor,
        hotkeys,
        widget = wibox.container.margin,
        layout = wibox.layout.fixed.horizontal
    },
    forced_height = dpi(50),
    forced_width = dpi(230),
    margins = dpi(12),
    widget = wibox.container.margin,
    layout = wibox.layout.fixed.vertical
}
--places
local places_widget =
    wibox.widget {
    {
        helpers.horizontal_pad(dpi(10)),
        home,
        Downloads,
        Documents,
        Root,
        spacing = dpi(12),
        forced_height = dpi(50),
        widget = wibox.container.margin,
        layout = wibox.layout.fixed.horizontal
    },
    {
        helpers.horizontal_pad(dpi(10)),
        Pictures,
        Music,
        Videos,
        Trash,
        spacing = dpi(12),
        widget = wibox.container.margin,
        forced_height = dpi(50),
        layout = wibox.layout.fixed.horizontal
    },
    margins = dpi(12),
    widget = wibox.container.margin,
    layout = wibox.layout.fixed.vertical
}

--importing stuff
local playerctl = require("widget.playerctl.music-player")
local audio = require("panels.dashboard.set-audio-sink")
local wifi = require ("panels.dashboard.wifi")
local airplane = require("panels.dashboard.airplane_mode")
local bluetooth = require("panels.dashboard.bluetooth")
local microphone = require("panels.dashboard.microphone")
local night_light = require("panels.dashboard.night_light")
local user_profile = require("widget.user-profile")
local search_box = require("panels.dashboard.search-box")
local sysmon = require("panels.dashboard.system_monitor")
local volume_bar = require("widget.volume-slider")
local brightness_bar = require("widget.brightness-slider")
local settings_widget =
    wibox.widget {
    {
        volume_bar,
        widget = wibox.container.margin,
        forced_height = dpi(45),
        layout = wibox.layout.fixed.horizontal
    },
    {
        brightness_bar,
        widget = wibox.container.margin,
        forced_height = dpi(45),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical
}
--toggle apps
local toggle_buttons =
    wibox.widget {
    {
        helpers.horizontal_pad(dpi(24)),
        wifi,
        bluetooth,
        audio,
        night_light,
        spacing = dpi(12),
        forced_height = dpi(40),
        widget = wibox.container.margin,
        layout = wibox.layout.fixed.horizontal
    },
    {
        helpers.horizontal_pad(dpi(24)),
        airplane,
        microphone,
        widget = wibox.container.margin,
        spacing = dpi(12),
        forced_height = dpi(40),
        layout = wibox.layout.fixed.horizontal
    },
    spacing = dpi(5),
    margins = dpi(12),
    widget = wibox.container.margin,
    layout = wibox.layout.fixed.vertical
}
-- placing them in boxes
local apps_box = helpers.create_boxed_widget(apps_widget, dpi(270), dpi(40), beautiful.widget_bg_normal)
local places_widget_box = helpers.create_boxed_widget(places_widget, dpi(270), dpi(120), beautiful.widget_bg_normal)
local volume_box = helpers.create_boxed_widget(settings_widget, dpi(270), dpi(100), beautiful.widget_bg_normal)
local user_system_monitor = helpers.create_boxed_widget(sysmon, dpi(270), dpi(120), beautiful.widget_bg_normal)
local toggle_apps = helpers.create_boxed_widget(toggle_buttons, dpi(270), dpi(120), beautiful.widget_bg_normal)

-- =========================================================
-- ======================== PANEL ==========================
-- =========================================================

dashboard.create = function(s)
    local panel =
        awful.popup {
        ontop = true,
        screen = s,
        visible = false,
        type = "dock",
        minimum_height = beautiful.dashboard_min_height,
        maximum_height = beautiful.dashboard_max_height,
        minimum_width = beautiful.dashboard_min_width,
        maximum_width = beautiful.dashboard_max_width,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        shape = helpers.prrect(dpi(12), true, true, true, true),
        placement = function(w)
            awful.placement.top_right(
                w,
                {
                    margins = {bottom = dpi(5), top = beautiful.wibar_height + dpi(5), left = dpi(5), right = dpi(5)}
                }
            )
        end,
        widget = {
            {
                {
                    {
                        nil,
                        {
                            {
                                {
                                    user_profile,
                                    user_system_monitor,
                                    places_widget_box,
                                    -- apps_box,
                                    spacing = dpi(15),
                                    layout = wibox.layout.fixed.vertical
                                },
                                expand = "none",
                                margins = dpi(8),
                                widget = wibox.container.margin
                            },
                            {
                                {
                                    volume_box,
                                    toggle_apps,
                                    playerctl,
                                    spacing = dpi(15),
                                    layout = wibox.layout.fixed.vertical
                                },
                                expand = "none",
                                margins = dpi(8),
                                widget = wibox.container.margin
                            },
                            layout = wibox.layout.align.horizontal
                        },
                        {
                            {
                                -- search_box,
                                halign = "center",
                                valign = "center",
                                widget = wibox.container.place
                            },
                            expand = "none",
                            margins = dpi(8),
                            widget = wibox.container.margin
                        },
                        layout = wibox.layout.align.vertical
                    },
                    margins = dpi(4),
                    widget = wibox.container.margin
                },
                shape = helpers.prrect(beautiful.widget_box_radius * 2, true, true, false, false),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
            },
            layout = wibox.layout.align.vertical
        }
    }

    panel.opened = false

    awesome.connect_signal("dashboard::toggle", function(scr)
		if scr == s then
			s.dashboard.visible = not s.dashboard.visible
		end
	end)

    return panel
end
return dashboard
