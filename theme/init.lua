---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi
local gears = require("gears")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local pallete = require("theme.pallete")
local helper = require("helper")

local theme = {}

theme.font = "Roboto"
theme.font_alt = "Roboto Mono Nerd Font"
theme.icon_font = "Symbols Mono Nerd Font"

theme.bg_normal = pallete.black
theme.bg_focus = pallete.background2
theme.bg_urgent = pallete.red
theme.bg_minimize = pallete.background2

theme.accent = pallete.accent

theme.module_bg = pallete.background
theme.module_bg_focused = pallete.background2

theme.bg_systray = theme.module_bg

theme.fg_normal = pallete.foreground
theme.fg_focus = pallete.foreground
theme.fg_urgent = pallete.black
theme.fg_minimize = pallete.black

theme.useless_gap = dpi(3)
theme.gap_single_client = false
theme.border_width = dpi(1)
theme.border_color_normal = pallete.black
theme.border_color_active = pallete.border
theme.border_color_marked = pallete.brightgreen

theme.taglist_bg_empty = theme.module_bg
theme.taglist_bg_occupied = theme.module_bg
theme.taglist_bg_urgent = theme.module_bg
theme.taglist_bg_focus = pallete.background
theme.taglist_font = theme.icon_font .. " 11"
theme.taglist_spacing = dpi(2)
theme.taglist_fg_focus = theme.accent
theme.taglist_fg_occupied = pallete.foreground
theme.taglist_fg_urgent = pallete.brightred
theme.taglist_fg_empty = pallete.brightblack
theme.taglist_shape = helper.rounded_rect(dpi(4))

theme.tasklist_bg_normal = theme.module_bg
theme.tasklist_bg_focus = theme.accent
theme.tasklist_bg_urgent = theme.module_bg_focused
theme.tasklist_fg_urgent = pallete.brightred

theme.menu_font = theme.font_alt .. " 9"
theme.menu_height = dpi(20)
theme.menu_width = dpi(100)
theme.menu_border_color = pallete.brightblack
theme.menu_border_width = dpi(2)
theme.menu_fg_focus = pallete.black
theme.menu_bg_focus = theme.accent
theme.menu_fg_normal = pallete.foreground
theme.menu_bg_normal = pallete.background

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_bg = pallete.background2
theme.notification_fg = pallete.foreground
theme.notification_width = dpi(360)
theme.notification_margin = dpi(120)
theme.notification_border_width = dpi(2)
theme.notification_border_color = pallete.border
theme.notification_border_shape = helper.rounded_rect(dpi(12))
theme.notification_icon_size = dpi(100)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

---@diagnostic disable-next-line: param-type-mismatch
theme.wallpaper = gears.surface.load_uncached(gfs.get_configuration_dir() .. pallete.wallpaper)
theme.pfp = gfs.get_configuration_dir() .. "assets/pfp.gif"
theme.cover_art = gfs.get_configuration_dir() .. "assets/albumart.jpg"

local layouts = {
    layout_fairh = themes_path .. "default/layouts/fairhw.png",
    layout_fairv = themes_path .. "default/layouts/fairvw.png",
    layout_floating = themes_path .. "default/layouts/floatingw.png",
    layout_magnifier = themes_path .. "default/layouts/magnifierw.png",
    layout_max = themes_path .. "default/layouts/maxw.png",
    layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png",
    layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png",
    layout_tileleft = themes_path .. "default/layouts/tileleftw.png",
    layout_tile = themes_path .. "default/layouts/tilew.png",
    layout_tiletop = themes_path .. "default/layouts/tiletopw.png",
    layout_spiral = themes_path .. "default/layouts/spiralw.png",
    layout_dwindle = themes_path .. "default/layouts/dwindlew.png",
    layout_cornernw = themes_path .. "default/layouts/cornernww.png",
    layout_cornerne = themes_path .. "default/layouts/cornernew.png",
    layout_cornersw = themes_path .. "default/layouts/cornersww.png",
    layout_cornerse = themes_path .. "default/layouts/cornersew.png",
}

-- You can use your own layout icons like this:
theme.layout_tile = gears.color.recolor_image(layouts.layout_tile, theme.accent)
theme.layout_floating = gears.color.recolor_image(layouts.layout_floating, theme.accent)
theme.layout_tiletop = gears.color.recolor_image(layouts.layout_tiletop, theme.accent)

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Papirus-Dark"

-- Set different colors for urgent notifications.
rnotification.connect_signal(
    "request::rules",
    function()
        rnotification.append_rule({
            rule = { urgency = "critical" },
            properties = { bg = pallete.red, fg = pallete.black },
        })
    end
)

return theme
