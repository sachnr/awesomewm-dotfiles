-- ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
-- ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--    ██║   ███████║█████╗  ██╔████╔██║█████╗
--    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝

-- =========================================================
-- ======================= Import ==========================
-- =========================================================

local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("client.helpers")
local gears = require("gears")
local gfs = require("gears.filesystem")

-- define module table
local theme = {}

-- =========================================================
-- ======================= Pallete =========================
-- =========================================================

--gruvbox
theme.bg0_h = "#1D2021"
theme.bg0 = "#282828"
theme.bg1 = "#3C3836"
theme.bg2 = "#504945"
theme.bg3 = "#665C54"
theme.bg4 = "#7C6F64"
theme.gray = "#928374"
theme.fg0 = "#FBF1C7"
theme.fg1 = "#EBDBB2"
theme.fg2 = "#D5C4A1"
theme.fg3 = "#BDAE93"
theme.fg4 = "#A89984"
theme.bg0_s = "#32302F"
theme.red = "#FB4934"
theme.green = "#B8BB26"
theme.yellow = "#FABD2F"
theme.blue = "#83A598"

-- =========================================================
-- =================== THEME VARIABLES =====================
-- =========================================================

-- ------- Wallpaper ---------
theme.music = gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "wallpapers/music.png")
awful.spawn("feh --randomize --bg-fill " .. gears.filesystem.get_configuration_dir() .. "wallpapers/gruvbox/gruvbox0.png")

-- ---- profile picture ------
theme.pfp = gears.filesystem.get_configuration_dir() .. "icons/user/profile.jpg"

-- --------- wibar -----------
theme.wibar_height = dpi(36)

-- --------- gaps ------------
theme.useless_gap = dpi(8)
theme.gap_single_client = true

-- --------- Fonts -----------
theme.title_fonts = "Roboto Mono Nerd Fonts Bold 11"
theme.normal_fonts = "Roboto 11"
theme.monospace = "Roboto Mono Nerd Fonts 10"
theme.monospace_bold = "Roboto Mono Nerd Fonts Bold 10"
theme.icon_fonts =  "Material Icons Round 14"

-- -- clickable container ----
theme.mouse_enter = theme.bg0
theme.mouse_leave = theme.bg0_h
theme.mouse_press = theme.bg0 .. "80"
theme.mouse_release = theme.bg0

-- -------- accent -----------
theme.accent_normal = theme.bg1

-- -------- accent titlebar-----------
theme.accent_normal_c = theme.red
theme.accent_mouse_enter = theme.red .. "a0"
theme.accent_mouse_press = theme.red .. "80"
theme.accent_normal_alt = theme.green 
theme.accent_mouse_enter_alt = theme.green .. "a0"
theme.accent_mouse_press_alt = theme.green 
theme.accent_normal_alt_alt = theme.yellow 
theme.accent_mouse_enter_alt_alt = theme.yellow .. "a0"
theme.accent_mouse_press_alt_alt = theme.yellow .. "80"

-- ------ foreground ---------
theme.fg_normal = theme.fg1
theme.fg_critical = theme.fg0

-- ------ background ---------
theme.bg_normal = theme.bg0_h
theme.bg_critical = theme.red
theme.transparent = "#22000000"

-- -------- client -----------
theme.titlebars_enabled = true
theme.titlebar_buttonsize_alt = dpi(16)
theme.titlebar_buttonsize = dpi(16)
theme.titlebar_size = dpi(25)
theme.titlebar_color = theme.bg0_h
theme.border_width = dpi(2)
theme.border_accent = theme.bg1
-- theme.corner_radius = dpi(8)

-- -------- widgets ----------
theme.widget_box_radius = dpi(12)
theme.widget_box_gap = dpi(8)
theme.widget_margin_color = "#FF000000"
theme.widget_bg_normal = theme.bg0

-- ------- LayoutBox ---------
theme.layoutbox_width = dpi(24)

-- ------- dashboard ---------
theme.dashboard_min_height = dpi(480)
theme.dashboard_max_height = dpi(480)
theme.dashboard_max_width = dpi(600)
theme.dashboard_min_width = dpi(600)
theme.dashboard_margin = dpi(2)
theme.dashboard_margin_color= theme.bg1

-- ------ System Tray --------
theme.systray_icon_spacing = dpi(8)
theme.bg_systray = theme.bg0_h

-- --------- Menu ------------
theme.menu_font = "Roboto 9"
theme.menu_height = dpi(24)
theme.menu_width = dpi(120)
theme.menu_border_color = theme.bg1
theme.menu_border_width = dpi(2)
theme.menu_fg_focus = theme.fg0
theme.menu_bg_focus = theme.bg0
theme.menu_fg_normal = theme.fg1
theme.menu_bg_normal = theme.bg2

-- ------- TaskList ----------
theme.tasklist_font = "Roboto Mono Nerd Fonts Bold 9"
theme.tasklist_bg_normal =  theme.bg0_s
theme.tasklist_bg_focus = theme.bg0_s .. "4f"
theme.tasklist_bg_urgent = theme.red
theme.tasklist_fg_focus = theme.fg0
theme.tasklist_fg_urgent = theme.fg0
theme.tasklist_fg_normal = theme.fg1
-- theme.tasklist_disable_task_name = true
theme.tasklist_shape = helpers.rect(dpi(4))

-- -------- Taglist ----------
theme.taglist_shape_border_width = dpi(2)
theme.taglist_shape_border_width_empty = dpi(2)
theme.taglist_shape_border_width_focus = dpi(2)
theme.taglist_shape_border_color = theme.bg1
theme.taglist_shape_border_color_empty = theme.bg0_h
theme.taglist_shape_border_color_focus = theme.bg4
theme.taglist_bg_empty = theme.bg0_h
theme.taglist_bg_occupied = theme.bg0_h
theme.taglist_bg_urgent = theme.red
theme.taglist_bg_focus = theme.bg0_h
-- theme.taglist_font = theme.title_fonts
-- theme.taglist_spacing     = 2
-- theme.taglist_fg_focus    = theme.nord6
-- theme.taglist_fg_occupied = theme.nord4
-- theme.taglist_fg_urgent   = theme.nord11
-- theme.taglist_fg_empty    = theme.nord9
theme.taglist_shape = helpers.squircle(dpi(2))
theme.taglist_shape_focus = helpers.squircle(dpi(6))

-- ------- Snapping ----------
theme.snap_bg = theme.bg1
theme.snap_border_width = dpi(1)

-- ---- Toggle buttons -------
theme.toggle_button_inactive = theme.bg2
theme.toggle_button_active = theme.blue

-- --------- music -----------
theme.playerctl_ignore  = "firefox"
theme.playerctl_player  = {"ncmpcpp", "vlc", "%any"}

-- ------- date/time ---------
theme.date_time_color = theme.yellow

-- --------- Icons -----------
theme.icon_color = theme.fg1
-- layout icons
theme.layout_tile = gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/tile.svg", theme.icon_color)
theme.layout_floating = gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/float.svg", theme.icon_color)
-- theme.layout_max = "~/.config/awesome/icons/layout/maximized.png"
theme.layout_centered = gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/bling.svg", theme.icon_color)

theme.icon_theme = "Papirus Dark"


-- return theme
return theme