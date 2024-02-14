local wibox = require("wibox")
local beautiful = require("beautiful")
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

local bar = {}

bar.setup = function(args)
	setmetatable(args, { __index = { style = "horizontal" } })
	local style = args.style

	--      ────────────────────────────────────────────────────────────
	-- local layout = require("bar.modules.layoutbox")
	local datetime = require("bar.modules.datetime").setup(style)
	local redshift = require("bar.modules.redshift")
	local taglist = require("bar.modules.taglist")
	local tasklist = require("bar.modules.tasklist")
	local power = require("bar.modules.power")
	local systray = require("bar.modules.systray")(style)
	local pipewire = require("bar.modules.pipewire").setup(style)
	local mpd = require("bar.modules.mpd").setup(style)
	local pomodoro = require("bar.modules.pomodoro").setup(style)
	--      ────────────────────────────────────────────────────────────

	---@diagnostic disable-next-line: undefined-global
	screen.connect_signal("request::desktop_decoration", function(s)
		awful.tag({ " ", " ", " ", "󰉋 ", "󰵅 ", "󰊠 ", " " }, s, awful.layout.layouts[1])

		s.calendar = require("bar.modules.calendar").setup(s, style)
		s.dashboard = require("bar.modules.power.dashboard").setup(s, style)
		s.music_panel = require("bar.modules.mpd.popup").setup(s, style)

		if style == "vertical" then
			s.mywibox = awful.wibar({
				position = "right",
				screen = s,
				width = dpi(45),
				widget = {
					layout = wibox.layout.align.vertical,
					expand = "none",
					{ -- Left widgets
						layout = wibox.layout.fixed.vertical,
						-- layout(s),
						datetime,
						pipewire,
						mpd,
						pomodoro,
					},
					{ -- Middle widget
						layout = wibox.layout.flex.vertical,
						taglist(s, style),
					},
					{ -- Right widgets
						layout = wibox.layout.fixed.vertical,
						tasklist(s, style),
						systray,
						redshift,
						power,
					},
				},
			})
		end

		if style == "horizontal" then
			s.mywibox = awful.wibar({
				position = "top",
				screen = s,
				height = dpi(32),
				widget = {
					layout = wibox.layout.align.horizontal,
					expand = "none",
					{ -- Left widgets
						-- layout(s),
						taglist(s, style),
						tasklist(s, style),
						-- pomodoro,
						layout = wibox.layout.fixed.horizontal,
					},
					{ -- Middle widget
						mpd,
						layout = wibox.layout.flex.horizontal,
					},
					{ -- Right widgets
						layout = wibox.layout.fixed.horizontal,
						pomodoro,
						systray,
						pipewire,
						redshift,
						datetime,
						power,
					},
				},
			})
		end
	end)
end

return bar
