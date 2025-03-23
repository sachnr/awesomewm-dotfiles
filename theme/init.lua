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
local pallete = require("theme.gtk")

local theme = {}

theme.font = pallete.font_family
theme.font_alt = pallete.font_family
theme.font_size = pallete.font_size
theme.icon_font = "Symbols Nerd Font Mono"

theme.bg_normal = pallete.bg_color
theme.bg_focus = pallete.selected_bg_color
theme.bg_warning = pallete.warning_bg_color
theme.bg_urgent = pallete.error_bg_color
theme.bg_success = pallete.success_bg_color
theme.bg_minimize = pallete.tooltip_bg_color

theme.accent = pallete.selected_bg_color

theme.module_bg = pallete.button_bg_color
theme.module_bg_focused = pallete.selected_bg_color

theme.bg_systray = pallete.bg_color
theme.systray_icon_spacing = dpi(4)

theme.fg_normal = pallete.fg_color
theme.fg_focus = pallete.selected_fg_color
theme.fg_warning = pallete.warning_fg_color
theme.fg_urgent = pallete.error_fg_color
theme.fg_success = pallete.success_fg_color
theme.fg_minimize = pallete.tooltip_fg_color

-- theme.useless_gap = dpi(4)
theme.gap_single_client = true
theme.border_width = dpi(2)
theme.border_color_normal = pallete.wm_border_unfocused_color
theme.border_color_active = pallete.wm_border_focused_color
theme.border_color_marked = theme.accent

theme.taglist_bg_empty = "#00000000"
theme.taglist_bg_occupied = pallete.button_bg_color
theme.taglist_bg_urgent = "#00000000"
theme.taglist_bg_focus = pallete.selected_bg_color
theme.taglist_font = theme.font .. " " .. pallete.font_size
theme.taglist_fg_focus = pallete.selected_fg_color
theme.taglist_fg_occupied = pallete.osd_fg_color
theme.taglist_fg_urgent = pallete.error_fg_color
theme.taglist_fg_empty = pallete.button_fg_color
theme.taglist_shape = function(cx, width, height)
	gears.shape.rounded_rect(cx, width, height, dpi(6))
end

theme.tasklist_bg_normal = theme.module_bg
theme.tasklist_bg_focus = theme.accent
theme.tasklist_bg_urgent = theme.module_bg_focused
theme.tasklist_fg_urgent = pallete.error_fg_color

theme.menu_font = theme.font_alt .. " 9"
theme.menu_height = dpi(20)
theme.menu_width = dpi(100)
theme.menu_border_color = pallete.wm_border_unfocused_color
theme.menu_border_width = dpi(2)
theme.menu_fg_focus = pallete.selected_fg_color
theme.menu_bg_focus = pallete.selected_bg_color
theme.menu_fg_normal = pallete.menubar_fg_color
theme.menu_bg_normal = pallete.menubar_bg_color

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_bg = pallete.tooltip_bg_color
theme.notification_fg = pallete.tooltip_fg_color
theme.notification_width = dpi(360)
theme.notification_margin = dpi(120)
theme.notification_border_width = dpi(2)
theme.notification_border_color = pallete.wm_border_unfocused_color
theme.notification_border_shape = function(cx, w, h)
	gears.shape.rounded_rect(cx, w, h, dpi(12))
end
theme.notification_icon_size = dpi(100)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

---@diagnostic disable-next-line: param-type-mismatch
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
rnotification.connect_signal("request::rules", function()
	rnotification.append_rule({
		rule = { urgency = "critical" },
		properties = { bg = pallete.error_bg_color, fg = pallete.error_fg_color },
	})
end)

return theme
