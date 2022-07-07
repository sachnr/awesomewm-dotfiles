-- ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
-- ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--    ██║   ███████║█████╗  ██╔████╔██║█████╗
--    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝

-- =========================================================
-- ======================= Import ==========================
-- =========================================================

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
theme.wallpaper = gfs.get_configuration_dir() .. "wallpapers/gruvbox/gruvbox0.png"

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
theme.mouse_enter = theme.bg0_h
theme.mouse_leave = theme.bg0
theme.mouse_press = theme.bg0_h .. "80"
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
theme.tasklist_plain_task_name = true
theme.tasklist_shape = helpers.rect(dpi(4))

-- -------- Taglist ----------
theme.taglist_bg_empty = theme.bg0_h
theme.taglist_bg_occupied = theme.bg0_h
theme.taglist_bg_urgent = theme.bg0_h
theme.taglist_bg_focus = theme.bg0_h
theme.taglist_font = theme.title_fonts
theme.taglist_spacing     = dpi(6)
theme.taglist_fg_focus    = theme.yellow
theme.taglist_fg_occupied = theme.fg1
theme.taglist_fg_urgent   = theme.red
theme.taglist_fg_empty    = theme.bg3

-- --- tag preview bling -----
theme.tag_preview_widget_border_radius = theme.border_width        -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = theme.border_width / 2       -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1           -- Opacity of each client
theme.tag_preview_client_bg = theme.bg0_h           -- The bg color of each client
theme.tag_preview_client_border_color = theme.bg1 -- The border color of each client
theme.tag_preview_client_border_width = dpi(1)         -- The border width of each client
theme.tag_preview_widget_bg = theme.bg1          -- The bg color of the widget
theme.tag_preview_widget_border_color = theme.bg1 -- The border color of the widget
theme.tag_preview_widget_border_width = dpi(1)         -- The border width of the widget
theme.tag_preview_widget_margin = dpi(1)               -- The margin of the widget

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

-- ----- Hotkey popup --------
theme.hotkeys_shape             = helpers.rrect(dpi(6))
theme.hotkeys_border_width      = 0
theme.hotkeys_font              = "JetBrainsMono Nerd Font 11"
theme.hotkeys_group_margin 	    = 30
theme.hotkeys_label_bg          = theme.bg0_h
theme.hotkeys_label_fg          = theme.fg1
theme.hotkeys_description_font  = "JetBrains Mono Nerd Font 8"
theme.hotkeys_modifiers_fg      = theme.fg1
theme.hotkeys_bg                = theme.bg0_h

-- --------- Icons -----------
theme.icon_color = theme.fg1
-- layout icons
theme.layout_tile = gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/tile.svg", theme.icon_color)
theme.layout_floating = gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/float.svg", theme.icon_color)
theme.layout_centered = gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/bling.svg", theme.icon_color)

-- --------- extra -----------
-- theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
-- theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
-- theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
-- theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
-- theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
-- theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"
-- theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
-- theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
-- theme.layout_max        = themes_path.."default/layouts/maxw.png"
-- theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
-- theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"

theme.icon_theme = "Papirus Dark"


-- return theme
return theme