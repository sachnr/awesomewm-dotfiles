--  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
-- ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
-- ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
-- ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
-- ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝

-- =========================================================
-- ======================= IMPORTS =========================
-- =========================================================

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")
local with_dpi = require("beautiful").xresources.apply_dpi
local get_dpi = require("beautiful").xresources.get_dpi

local helpers = require("client.helpers")

--Rofi Launcher
local rofi_command =
    "env /usr/bin/rofi -dpi " ..
    get_dpi() ..
        " -width " ..
            with_dpi(400) .. " -show drun -theme " .. gears.filesystem.get_configuration_dir() .. "configs/rofi-drun.rasi"

-- =========================================================
-- ================= USER CONFIGURATION ====================
-- =========================================================

-- color scheme
local color_scheme = {
    "nord", --1
    "gruvbox" --2
}
local colors = color_scheme[2]

-- Default apps global variable
apps = {
    editor = "code",
    network_manager = "nm-connection-editor",
    power_manager = "xfce4-power-manager-settings",
    terminal = "alacritty",
    launcher = rofi_command,
    lock = "i3lock-fancy",
    screenshot = "flameshot gui",
    filebrowser = "nautilus",
    colorpicker = "gpick -p",
    browser = "firefox",
    taskmanager = "gnome-system-monitor",
    fontsandthemes = "lxappearance-gtk3",
    soundctrlpanel = "pavucontrol"
}

-- define wireless and ethernet interface names for the network widget
-- use `ip link` command to determine these
NETWORK = {
    wlan = "wlp1s0",
    lan = "enp4s0"
}

--OpenWeatherMap
WEATHER = {
    key = "sddadadsda",
    city_id = "1234567",
    units = "metric"
}

-- Startup apps

--- Polkit Agent
helpers.run_once_ps("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
--- picom
helpers.check_if_running(
    "picom",
    nil,
    function()
        awful.spawn("picom --experimental-backends --config " .. gears.filesystem.get_configuration_dir() .. "configs/picom.conf", false)
    end
)

local run_on_start_up = {
    "nm-applet --indicator", -- network applet
    "blueman-applet", --bluetooth applet
    "xfce4-power-manager", -- Power manager
    "flameshot", --Screenshot app
    "caffeine",
    "gpick",
    "mpd",
    "mpDris2",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
    -- Add applications inside awspawn that need to be killed between reloads to avoid multiple instances,
    "~/.config/awesome/configs/awspawn"
}

-- =========================================================
-- =================== DEFINE LAYOUTS ======================
-- =========================================================

-- https://awesomewm.org/doc/api/libraries/awful.layout.html#Client_layouts
-- set icons in the theme file

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

-- =========================================================
-- ======================== SETUP ==========================
-- =========================================================

-- ----- Import theme --------
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. colors .. "_pallete.lua")

--  Run all the apps listed in run_on_start_up
for _, app in ipairs(run_on_start_up) do
    local findme = app
    local firstspace = app:find(" ")
    if firstspace then
        findme = app:sub(0, firstspace - 1)
    end
    -- pipe commands to bash to allow command to be shell agnostic
    awful.spawn.with_shell(
        string.format("echo 'pgrep -u $USER -x %s > /dev/null || (%s)' | bash -", findme, app),
        false
    )
end

-- ----- import panel --------
require("panels")

--- ------ Import Tags --------
require("panels.tags")

-- comment this if you dont want titlebars
require("client.titlebar")
-- require("client.round-corners")

-- - Import notifications ----
require("client.notification")

-- Import Keybinds
local keys = require("client.keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("client.rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- import widgets
require("widget.volume-slider.volume-osd")
require("widget.weather.weather_main")
require("widget.brightness-slider.brightness-osd")
require("widget.exit-screen")

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the window as a slave (put it at the end of others instead of setting it as master)
        if not awesome.startup then
            awful.client.setslave(c)
        end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Make the focused window have a glowing border
_G.client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_accent
    end
)
_G.client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.bg_normal
    end
)

-- =========================================================
-- =================== CLIENT FOCUSING =====================
-- =========================================================

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

-- =========================================================
-- ============= Drag to the top to maximize ===============
-- =========================================================

awful.mouse.resize.add_leave_callback(
    function(c, _, args)
        if (not c.floating) and awful.layout.get(c.screen) ~= awful.layout.suit.floating then
            return
        end

        local coords = mouse.coords()
        local sg = c.screen.geometry
        local snap = awful.mouse.snap.default_distance

        if coords.x > snap + sg.x and coords.x < sg.x + sg.width - snap and coords.y <= snap + sg.y and coords.y >= sg.y then
            awful.placement.maximize(c, {honor_workarea = true})
        end
    end,
    "mouse.move"
)

-- =========================================================
--  Garbage collection (allows for lower memory consumption) =
-- =========================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
