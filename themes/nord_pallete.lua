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

--nord pallete
theme.nord0 = "#2e3440";
theme.nord1 = "#3b4252";
theme.nord2 = "#434c5e";
theme.nord3 = "#4c566a";
theme.nord4 = "#d8dee9";
theme.nord5 = "#e5e9f0";
theme.nord6 = "#eceff4";
theme.nord7 = "#8fbcbb";
theme.nord8 = "#88c0d0";
theme.nord9 = "#81a1c1";
theme.nord10 = "#5e81ac";
theme.nord11 = "#bf616a";
theme.nord12 = "#d08770";
theme.nord13 = "#ebcb8b";
theme.nord14 = "#a3be8c";
theme.nord15 = "#b48ead";

-- =========================================================
-- =================== THEME VARIABLES =====================
-- =========================================================

-- ------- Wallpaper ---------
theme.music = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "wallpapers/music.png")
awful.spawn("feh --bg-fill " .. gears.filesystem.get_configuration_dir() .. "wallpapers/Nord-underwater.png", false)

-- ---- profile picture ------
theme.pfp = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/user/profile.jpg")

-- --------- wibar -----------
theme.wibar_height = dpi(36)

-- --------- gaps ------------
theme.useless_gap = dpi(10)
theme.gap_single_client = true

-- --------- Fonts -----------
theme.title_fonts = "Roboto Mono Nerd Fonts Bold 11"
theme.normal_fonts = "Roboto 11"
theme.monospace = "Roboto Mono Nerd Fonts 10"
theme.monospace_bold = "Roboto Mono Nerd Fonts Bold 10"
theme.icon_fonts =  "Material Icons Round 14"

-- -- clickable container ----
theme.mouse_enter = theme.nord10 .. "50"
theme.mouse_leave = theme.nord10 .. "00"
theme.mouse_press = theme.nord10 .. "60"
theme.mouse_release = theme.nord10 .. "30"

-- -------- accent -----------
theme.accent_normal = theme.nord9

-- -------- accent titlebar -----------
theme.accent_normal_c = theme.nord9
theme.accent_mouse_enter = theme.nord10
theme.accent_mouse_press = theme.nord8
theme.accent_normal_alt = theme.nord3 .. "80"
theme.accent_mouse_enter_alt = theme.nord3
theme.accent_mouse_press_alt = theme.nord3 .. "60"
theme.accent_normal_alt_alt = theme.nord3 .. "80"
theme.accent_mouse_enter_alt_alt = theme.nord3
theme.accent_mouse_press_alt_alt = theme.nord3 .. "60"

-- ------ foreground ---------
theme.fg_normal = theme.nord6
theme.fg_critical = theme.nord6

-- ------ background ---------
theme.bg_normal = "#242933"
theme.bg_inactive = theme.nord3
theme.bg_critical = theme.nord11
theme.transparent = "#22000000"

-- -------- client -----------
theme.titlebars_enabled = true
theme.titlebar_buttonsize_alt = dpi(18)
theme.titlebar_buttonsize = dpi(20)
theme.titlebar_size = dpi(25)
theme.titlebar_color = theme.nord0
theme.border_width = dpi(1)
theme.border_accent = theme.nord10
-- theme.corner_radius = dpi(8)

-- -------- widgets ----------
theme.widget_box_radius = dpi(12)
theme.widget_box_gap = dpi(8)
theme.widget_margin_color = "#FF000000"
theme.widget_bg_normal = theme.nord0

-- ------- LayoutBox ---------
theme.layoutbox_width = dpi(24)

-- ------- dashboard ---------
theme.dashboard_min_height = dpi(480)
theme.dashboard_max_height = dpi(480)
theme.dashboard_max_width = dpi(600)
theme.dashboard_min_width = dpi(600)
theme.dashboard_margin = dpi(2)
theme.dashboard_margin_color= theme.nord0

-- ------ System Tray --------
theme.systray_icon_spacing = dpi(8)
theme.bg_systray = theme.bg_normal

-- --------- Menu ------------
theme.menu_font = "Roboto 9"
theme.menu_height = dpi(24)
theme.menu_width = dpi(120)
theme.menu_border_color = theme.nord0
theme.menu_border_width = dpi(2)
theme.menu_fg_focus = theme.nord6 .. "20"
theme.menu_bg_focus = theme.nord2
theme.menu_fg_normal = theme.nord6
theme.menu_bg_normal = theme.nord1

-- ------- TaskList ----------
theme.tasklist_font = "Roboto Mono Nerd Fonts Bold 9"
theme.tasklist_bg_normal =  theme.nord1
theme.tasklist_bg_focus = theme.nord9 .. "4f"
theme.tasklist_bg_urgent = theme.nord15
theme.tasklist_fg_focus = theme.nord6
theme.tasklist_fg_urgent = theme.nord6
theme.tasklist_fg_normal = theme.nord4
-- theme.tasklist_disable_task_name = true
theme.tasklist_shape = helpers.rect(dpi(4))

-- -------- Taglist ----------
theme.taglist_shape_border_width = dpi(2)
theme.taglist_shape_border_width_empty = dpi(2)
theme.taglist_shape_border_width_focus = dpi(2)
theme.taglist_shape_border_color = theme.nord10
theme.taglist_shape_border_color_empty = theme.bg_normal
theme.taglist_shape_border_color_focus = theme.nord8
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = theme.nord3
theme.taglist_bg_urgent = theme.nord11
theme.taglist_bg_focus = theme.nord2
-- theme.taglist_font = theme.title_fonts
theme.taglist_spacing     = 2
-- theme.taglist_fg_focus    = theme.nord6
-- theme.taglist_fg_occupied = theme.nord4
-- theme.taglist_fg_urgent   = theme.nord11
-- theme.taglist_fg_empty    = theme.nord9
theme.taglist_shape = helpers.squircle(dpi(2))
theme.taglist_shape_focus = helpers.squircle(dpi(6))

-- ------- Snapping ----------
theme.snap_bg = theme.nord9
theme.snap_border_width = dpi(1)

-- ---- Toggle buttons -------
theme.toggle_button_inactive = theme.nord3
theme.toggle_button_active = theme.nord10

-- --------- music -----------
theme.playerctl_ignore  = "firefox"
theme.playerctl_player  = {"ncmpcpp", "vlc", "%any"}

-- ------- date/time ---------
theme.date_time_color = theme.nord10

-- --------- Icons -----------
-- layout icons
theme.layout_tile = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/layout/tile.svg")
theme.layout_floating = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/layout/float.svg")
-- theme.layout_max = "~/.config/awesome/icons/layout/maximized.png"
theme.layout_centered = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/layout/bling.svg")

theme.icon_theme = "Papirus Dark"

-- return theme
return theme