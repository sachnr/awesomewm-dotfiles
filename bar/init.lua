local wibox = require("wibox")
local beautiful = require("beautiful")
local systray = require("bar.modules.systray")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
---@diagnostic disable-next-line: undefined-global
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.floating,
	})
end)

local tags = {}
local bar = {}

bar.setup = function(args)
	setmetatable(args, { __index = { style = "horizontal" } })

	local fancy_taglist = require("bar.modules.taglist")
	local time = require("bar.modules.time")
	local volume = require("bar.modules.volume")
	local mpd_text = require("bar.modules.mpd")

	require("bar.modules.lain_mpd")()

	---@diagnostic disable-next-line: undefined-global
	awful.screen.connect_for_each_screen(function(s)
		tags[s] = awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

		s.mywibox = awful.wibar({
			position = "bottom",
			screen = s,
			height = dpi(28),
			widget = {
				layout = wibox.layout.align.horizontal,
				expand = "none",
				{ -- Left widgets
					fancy_taglist.setup(s),
					layout = wibox.layout.fixed.horizontal,
				},
				{ -- Middle widget
					mpd_text.setup(),
					layout = wibox.layout.flex.horizontal,
				},
				{ -- Right widgets
					volume.setup(),
					time.setup(),
					systray.setup(),
					layout = wibox.layout.fixed.horizontal,
				},
			},
		})
	end)
end

return bar
