-- =========================================================
-- ======================= IMPORTS =========================
-- =========================================================

local awful = require("awful")
local gears = require("gears")
local icons = require("icons.flaticons")

-- dpi fix
local beautiful = require("beautiful")
local with_dpi = beautiful.xresources.apply_dpi
local get_dpi = beautiful.xresources.get_dpi

-- --Rofi Launcher
-- local rofi_command =
--   "env /usr/bin/rofi -dpi " ..
--   get_dpi() ..
--     " -width " ..
--       with_dpi(400) .. " -show drun -theme " .. gears.filesystem.get_configuration_dir() .. "/configs/rofi.rasi"

-- local Defaultapps = {
--   rofi = rofi_command,
--   browser = rofi_command,
--   files = rofi_command,
--   editor = rofi_command,
--   game = rofi_command,
--   social = rofi_command,
--   music = rofi_command
-- }

-- local tags = {
--   {
--     icon = icons.browser,
--     type = "browser",
--     defaultApp = Defaultapps.browser,
--     screen = 1
--   },
--   {
--     icon = icons.code,
--     type = "code",
--     defaultApp = Defaultapps.editor,
--     screen = 1
--   },
--   {
--     icon = icons.folder,
--     type = "files",
--     defaultApp = Defaultapps.files,
--     screen = 1
--   },
--   {
--     icon = icons.game,
--     type = "game",
--     defaultApp = Defaultapps.game,
--     screen = 1
--   },
--   {
--     icon = icons.social,
--     type = "social",
--     defaultApp = Defaultapps.social,
--     screen = 1
--   },
--   {
--     icon = icons.music,
--     type = "music",
--     defaultApp = Defaultapps.music,
--     screen = 1
--   },
--   {
--     icon = icons.lab,
--     type = "any",
--     defaultApp = Defaultapps.rofi,
--     screen = 1
--   }
-- }

-- - add tag to all wibars ---

awful.screen.connect_for_each_screen(
  function(s)
    awful.tag({"1", "2", "3", "4", "5", "6"}, s, awful.layout.layouts[1])
  end
)
