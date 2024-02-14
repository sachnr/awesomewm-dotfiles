local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- ---@diagnostic disable-next-line: undefined-global
-- screen.connect_signal(
--     "request::wallpaper",
--     function(s)
--         awful.wallpaper({
--             screen = s,
--             widget = {
--                 {
--                     image = beautiful.wallpaper,
--                     resize = true,
--                     widget = wibox.widget.imagebox,
--                 },
--                 valign = "center",
--                 halign = "center",
--                 tiled = false,
--                 widget = wibox.container.tile,
--             },
--         })
--     end
-- )

-- Slideshow
---@diagnostic disable-next-line: undefined-global
screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper({
		screen = s,
		bg = "#000000",
		widget = {
			{
				image = gears.filesystem.get_random_file_from_dir(
					"/home/sachnr/wallpapers/home",
					{ ".jpg", ".png", ".svg" },
					true
				),
				resize = true,
				widget = wibox.widget.imagebox,
			},
			valign = "center",
			halign = "center",
			tiled = false,
			widget = wibox.container.tile,
		},
	})
end)

gears.timer({
	timeout = 300,
	autostart = true,
	callback = function()
		---@diagnostic disable-next-line: undefined-global
		for s in screen do
			s:emit_signal("request::wallpaper")
		end
	end,
})
