local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

-- Slideshow
---@diagnostic disable-next-line: undefined-global
screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper({
		screen = s,
		widget = {
			{
				horizontal_fit_policy = "fit",
				vertical_fit_policy = "fit",
				image = gears.surface.crop_surface({
					surface = gears.surface.load_uncached(
						gears.filesystem.get_random_file_from_dir(
							os.getenv("HOME") .. "/wallpapers/",
							{ ".jpg", ".png", ".svg" },
							true
						)
					),
					ratio = s.geometry.width / s.geometry.height,
				}),
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
