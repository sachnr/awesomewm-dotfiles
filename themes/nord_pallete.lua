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
local icons = require("icons.flaticons")
local awful = require("awful")

-- define module table
local theme = {}

-- =========================================================
-- ======================= Pallete =========================
-- =========================================================

--nord pallete
theme.nord0 = "#2e3440"
theme.nord1 = "#3b4252"
theme.nord2 = "#434c5e"
theme.nord3 = "#4c566a"
theme.nord4 = "#d8dee9"
theme.nord5 = "#e5e9f0"
theme.nord6 = "#eceff4"
theme.nord7 = "#8fbcbb"
theme.nord8 = "#88c0d0"
theme.nord9 = "#81a1c1"
theme.nord10 = "#5e81ac"
theme.nord11 = "#bf616a"
theme.nord12 = "#d08770"
theme.nord13 = "#ebcb8b"
theme.nord14 = "#a3be8c"
theme.nord15 = "#b48ead"

-- =========================================================
-- =================== THEME VARIABLES =====================
-- =========================================================

-- =========================================================
--  Script to change svg color (run this when changing theme)
-- =========================================================

awful.spawn.easy_async_with_shell(
    [[
        STR=$HOME"/.config/awesome/icons/places/*"
        STR2=$HOME"/.config/awesome/icons/flaticons/*"
        
        for x in $STR
        do
        sed -e "s/#EBDBB2/#e5e9f0/g" $x > temp
        mv temp $x
        done

        for x in $STR2
        do
        sed -e "s/#EBDBB2/#e5e9f0/g" $x > temp
        mv temp $x
        done
    ]]
)

-- ------- Wallpaper ---------
theme.music = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "wallpapers/music.png")
theme.wallpaper = gfs.get_configuration_dir() .. "wallpapers/Nord-underwater.png"

-- ---- profile picture ------
theme.pfp = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "icons/user/profile.jpg")

-- --------- wibar -----------
theme.wibar_height = dpi(36)

-- --------- gaps ------------
theme.useless_gap = dpi(4)
theme.gap_single_client = true

-- --------- Fonts -----------
theme.title_fonts = "Roboto Mono Nerd Fonts Bold 11"
theme.normal_fonts = "Roboto 11"
theme.monospace = "Roboto Mono Nerd Fonts 10"
theme.monospace_bold = "Roboto Mono Nerd Fonts Bold 10"
theme.icon_fonts = "Material Icons Round 14"

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
theme.close_icon = icons.close
theme.maximize_icon = icons.maximize
theme.minimize_icon = icons.minus

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
theme.dashboard_margin_color = theme.nord0

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
theme.tasklist_bg_normal = theme.nord1
theme.tasklist_bg_focus = theme.nord9 .. "4f"
theme.tasklist_bg_urgent = theme.nord15
theme.tasklist_fg_focus = theme.nord6
theme.tasklist_fg_urgent = theme.nord6
theme.tasklist_fg_normal = theme.nord4
-- theme.tasklist_disable_task_name = true
theme.tasklist_plain_task_name = true
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
theme.taglist_spacing = 2
-- theme.taglist_fg_focus    = theme.nord6
-- theme.taglist_fg_occupied = theme.nord4
-- theme.taglist_fg_urgent   = theme.nord11
-- theme.taglist_fg_empty    = theme.nord9
theme.taglist_shape = helpers.squircle(dpi(2))
theme.taglist_shape_focus = helpers.squircle(dpi(6))

-- --- tag preview bling -----
theme.tag_preview_widget_border_radius = dpi(0) -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = theme.border_width / 2 -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1 -- Opacity of each client
theme.tag_preview_client_bg = theme.bg_normal -- The bg color of each client
theme.tag_preview_client_border_color = theme.nord9 -- The border color of each client
theme.tag_preview_client_border_width = dpi(1) -- The border width of each client
theme.tag_preview_widget_bg = theme.nord9 -- The bg color of the widget
theme.tag_preview_widget_border_color = theme.nord9 -- The border color of the widget
theme.tag_preview_widget_border_width = dpi(0) -- The border width of the widget
theme.tag_preview_widget_margin = dpi(0) -- The margin of the widget

-- ------- Snapping ----------
theme.snap_bg = theme.nord9
theme.snap_border_width = dpi(1)

-- ---- Toggle buttons -------
theme.toggle_button_inactive = theme.nord3
theme.toggle_button_active = theme.nord10

-- --------- music -----------
theme.playerctl_ignore = "firefox"
theme.playerctl_player = {"mpv", "vlc", "%any"}

-- ------- date/time ---------
theme.date_time_color = theme.nord10

-- ------- calender ----------
theme.cal_header_bg = theme.transparent
theme.cal_week_bg = theme.transparent
theme.cal_header_fg = theme.accent_normal
theme.cal_focus_fg = theme.fg_normal
theme.cal_week_fg = theme.fg_normal

-- ----- Hotkey popup --------
theme.hotkeys_shape = helpers.rrect(dpi(12))
theme.hotkeys_border_width = dpi(1)
theme.hotkeys_font = "JetBrainsMono Nerd Font 11"
theme.hotkeys_group_margin = dpi(60)
theme.hotkeys_label_bg = theme.bg_normal
theme.hotkeys_label_fg = theme.bg_normal
theme.hotkeys_description_font = "JetBrains Mono Nerd Font 8"
theme.hotkeys_modifiers_fg = theme.fg_normal
theme.hotkeys_bg = theme.bg_normal

-- --- flash focus bling -----
theme.flash_focus_start_opacity = 0.7 -- the starting opacity
theme.flash_focus_step = 0.01 -- the step of animation

-- --------- Icons -----------
local themes_path = "/usr/share/awesome/themes/"
theme.icon_color = theme.fg_normal
-- layout icons
theme.layout_tile =
    gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/tile.svg", theme.icon_color)
theme.layout_floating =
    gears.color.recolor_image(gears.filesystem.get_configuration_dir() .. "icons/layout/float.svg", theme.icon_color)
theme.layout_max = gears.color.recolor_image(themes_path .. "default/layouts/fullscreenw.png", theme.icon_color)
theme.layout_dwindle = gears.color.recolor_image(themes_path .. "default/layouts/dwindlew.png", theme.icon_color)

theme.icon_theme = "Papirus Dark"

-- return theme
return theme
