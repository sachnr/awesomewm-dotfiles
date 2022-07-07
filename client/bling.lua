local awful = require("awful")
local wibox = require("wibox")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local bling = require("bling")

-- ------- wallapper ---------

bling.module.wallpaper.setup {
  set_function = bling.module.wallpaper.setters.random,
  screen = screen, -- The awesome 'screen' variable is an array of all screen objects
  wallpaper = {beautiful.wallpaper},
  change_timer = 631
}

-- -------- Taglist ----------

-- tag preview
bling.widget.tag_preview.enable {
  show_client_content = true,
  placement_fn = function(c)
    awful.placement.top(
      c,
      {
        margins = {
          top = beautiful.wibar_height + beautiful.useless_gap * 4
        }
      }
    )
  end,
  scale = 0.16,
  honor_padding = true,
  honor_workarea = true,
  background_widget = wibox.widget {
    -- Set a background image (like a wallpaper) for the widget
    image = beautiful.wallpaper,
    horizontal_fit_policy = "fit",
    vertical_fit_policy = "fit",
    widget = wibox.widget.imagebox
  }
}
