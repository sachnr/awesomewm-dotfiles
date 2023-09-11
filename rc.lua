---@diagnostic disable: different-requires
local beautiful = require("beautiful")
local theme = require("theme")

pcall(require, "luarocks.loader")
beautiful.init(theme)
require("awful.autofocus")
require("awful.hotkeys_popup.keys")
require("keys")
require("rules")
require("bar")
require("notifications")
require("autostart")

require("awful").screen.set_auto_dpi_enabled(true)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c) c:activate({ context = "mouse_enter", raise = false }) end)

-- dont maximize client automatically
client.connect_signal("request::manage", function(c)
    c.maximized = false
    c.maximized_horizontal = false
    c.maximized_vertical = false
    -- make floating windows always ontop
    if c.floating then c.ontop = true end
end)

---@diagnostic disable-next-line: param-type-mismatch
collectgarbage("setpause", 110)
---@diagnostic disable-next-line: param-type-mismatch
collectgarbage("setstepmul", 1000)
