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
local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("client.helpers")

-- define module table
local theme = {}

-- =========================================================
-- ======================= Pallete =========================
-- =========================================================

theme.bg1 = "#1E1F29"
theme.bg2 = "#20212B"
theme.Background = "#282A36"
theme.Current_Line = "#44475a"
theme.Comment = "#6272a4"
theme.Selection = "#44475a"
theme.Foreground = "#f8f8f2"
theme.Cyan = "#8be9fd"
theme.Green = "#50fa7b"
theme.Orange = "#ffb86c"
theme.Pink = "#ff79c6"
theme.Purple = "#bd93f9"
theme.Red = "#ff5555"
theme.Yellow = "#f1fa8c"

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
theme.mouse_enter = theme.Pink .. "50"
theme.mouse_leave = theme.Pink .. "00"
theme.mouse_press = theme.Pink .. "60"
theme.mouse_release = theme.Pink .. "30"

-- -------- accent -----------
theme.accent_normal = theme.Pink
theme.accent_mouse_enter = theme.Pink .. "b0"
theme.accent_mouse_press = theme.Pink .. "90"
theme.accent_normal_alt = theme.Pink .. "80"
theme.accent_mouse_enter_alt = theme.Pink  .. "60"
theme.accent_mouse_press_alt = theme.Pink .. "50"

-- ------ foreground ---------
theme.fg_normal = theme.Foreground
theme.fg_critical = theme.Foreground

-- ------ background ---------
theme.bg_normal = theme.bg1
theme.bg_inactive = theme.Background .. "60"
theme.bg_critical = theme.Red
theme.transparent = "#22000000"

-- -------- client -----------
theme.titlebars_enabled = true
theme.titlebar_buttonsize_alt = dpi(18)
theme.titlebar_buttonsize = dpi(20)
theme.titlebar_size = dpi(25)
theme.titlebar_color = theme.bg1
theme.border_width = dpi(.5)
theme.border_accent = theme.Purple
-- theme.corner_radius = dpi(8)

-- -------- widgets ----------
theme.widget_box_radius = dpi(12)
theme.widget_box_gap = dpi(8)
theme.widget_margin_color = "#FF000000"
theme.widget_bg_normal = theme.bg2

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
theme.bg_systray = theme.bg_normal

-- --------- Menu ------------
theme.menu_font = "Roboto 9"
theme.menu_height = dpi(24)
theme.menu_width = dpi(120)
theme.menu_border_color = theme.bg_normal
theme.menu_border_width = dpi(2)
theme.menu_fg_focus = theme.Foreground .. "20"
theme.menu_bg_focus = theme.Pink .. "30"
theme.menu_fg_normal = theme.Foreground
theme.menu_bg_normal = theme.bg2

-- ------- TaskList ----------
theme.tasklist_font = "Roboto Mono Nerd Fonts Bold 9"
theme.tasklist_bg_normal =  theme.bg2
theme.tasklist_bg_focus = theme.Selection
theme.tasklist_bg_urgent = theme.Pink .. "60"
theme.tasklist_fg_focus = theme.Foreground
theme.tasklist_fg_urgent = theme.Foreground
theme.tasklist_fg_normal = theme.Foreground
theme.tasklist_fg_minimize = theme.Purple
-- theme.tasklist_disable_task_name = true
theme.tasklist_shape = helpers.rect(dpi(4))

-- -------- Taglist ----------
theme.taglist_shape_border_width = dpi(2)
theme.taglist_shape_border_width_empty = dpi(2)
theme.taglist_shape_border_width_focus = dpi(2)
theme.taglist_shape_border_color = theme.Purple
theme.taglist_shape_border_color_empty = theme.bg_normal
theme.taglist_shape_border_color_focus = theme.Pink
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = theme.Purple .. "40"
theme.taglist_bg_urgent = theme.Red .. "40"
theme.taglist_bg_focus = theme.Pink .. "40"
theme.taglist_shape = helpers.squircle(dpi(2))
theme.taglist_shape_focus = helpers.squircle(dpi(6))

-- ------- Snapping ----------
theme.snap_bg = theme.Purple .. "10"
theme.snap_border_width = dpi(1)

-- ---- Toggle buttons -------
theme.toggle_button_inactive = theme.Current_Line
theme.toggle_button_active = theme.Pink .. "80"

-- --------- Icons -----------
-- layout icons
theme.layout_tile = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/layout/tile.svg")
theme.layout_floating = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/layout/float.svg")
-- theme.layout_max = "~/.config/awesome/icons/layout/maximized.png"
theme.layout_centered = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/layout/bling.svg")

theme.icon_theme = "Papirus Dark"

-- return theme
return theme