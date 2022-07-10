local bling = require("bling")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("client.helpers")
local mat_icon_button_rect = require("widget.icon-button.icon-button-rect")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")
local playerctl = bling.signal.playerctl.lib()

---- Music Player
---- ~~~~~~~~~~~~

-- buttons
local previous = mat_icon_button_rect(mat_icon(icons.prev, dpi(11)))
previous:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				playerctl:previous()
			end
		)
	)
)

local next = mat_icon_button_rect(mat_icon(icons.next, dpi(11)))
next:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				playerctl:next()
			end
		)
	)
)

local play = mat_icon_button_rect(mat_icon(icons.ppause, dpi(18)))
play:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				playerctl:play_pause()
			end
		)
	)
)

local music_text =
	wibox.widget(
	{
		font = beautiful.title_fonts,
		valign = "center",
		widget = wibox.widget.textbox
	}
)

local music_art =
	wibox.widget(
	{
		image = beautiful.music,
		resize = true,
		widget = wibox.widget.imagebox
	}
)

local music_art_container =
	wibox.widget(
	{
		music_art,
		forced_height = dpi(120),
		forced_width = dpi(120),
		widget = wibox.container.background
	}
)

local filter_color = {
	type = "linear",
	from = {0, 0},
	to = {0, 120},
	stops = {{0, beautiful.widget_bg_normal .. "cc"}, {1, beautiful.widget_bg_normal}}
}

local music_art_filter =
	wibox.widget(
	{
		{
			bg = filter_color,
			forced_height = dpi(120),
			forced_width = dpi(120),
			widget = wibox.container.background
		},
		direction = "east",
		widget = wibox.container.rotate
	}
)

local music_title =
	wibox.widget(
	{
		font = beautiful.title_fonts,
		valign = "center",
		widget = wibox.widget.textbox
	}
)

local music_artist =
	wibox.widget(
	{
		font = beautiful.monospace_bold,
		valign = "center",
		widget = wibox.widget.textbox
	}
)

local music =
	wibox.widget(
	{
		{
			{
				{
					music_art_container,
					music_art_filter,
					layout = wibox.layout.stack
				},
				{
					{
						{
							music_text,
							helpers.vertical_pad(dpi(15)),
							{
								{
									widget = wibox.container.scroll.horizontal,
									step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
									fps = 60,
									speed = 75,
									music_artist
								},
								{
									widget = wibox.container.scroll.horizontal,
									step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
									fps = 60,
									speed = 75,
									music_title
								},
								forced_width = dpi(270),
								layout = wibox.layout.fixed.vertical
							},
							layout = wibox.layout.fixed.vertical
						},
						nil,
						{
							{
								previous,
								play,
								next,
								layout = wibox.layout.flex.horizontal
							},
							forced_height = dpi(70),
							margins = dpi(16),
							widget = wibox.container.margin
						},
						expand = "none",
						layout = wibox.layout.align.vertical
					},
					top = dpi(9),
					bottom = dpi(9),
					left = dpi(10),
					right = dpi(10),
					widget = wibox.container.margin
				},
				layout = wibox.layout.stack
			},
			bg = beautiful.transparent,
			shape = helpers.rrect(beautiful.widget_box_radius),
			forced_width = dpi(270),
			forced_height = dpi(160),
			widget = wibox.container.background
		},
		margins = dpi(10),
		color = beautiful.transparent,
		widget = wibox.container.margin
	}
)

--- playerctl
--- -------------
playerctl:connect_signal(
	"metadata",
	function(_, title, artist, album_path, album, new, player_name)
		if title == "" then
			title = "Nothing Playing"
		end
		if artist == "" then
			artist = "Nothing Playing"
		end
		if album_path == "" then
			album_path = gears.filesystem.get_configuration_dir() .. "wallpapers/music.png"
		end
		if new == true then
			naughty.notification(
				{
					title = title,
					text = artist,
					image = album_path,
					shape = helpers.prrect(dpi(12)),
					margin = dpi(15),
					timeout = 5,
					width = dpi(270),
					font = beautiful.monospace_bold
				}
			)
		end
		music_art:set_image(gears.surface.load_uncached(album_path))
		music_title:set_markup_silently(helpers.colorize_text(title, beautiful.fg_normal))
		music_artist:set_markup_silently(helpers.colorize_text(artist, beautiful.blue or beautiful.accent_normal))
	end
)

playerctl:connect_signal(
	"playback_status",
	function(_, playing, __)
		if playing then
			music_text:set_markup_silently(helpers.colorize_text("Now Playing", beautiful.fg_normal))
		else
			music_text:set_markup_silently(helpers.colorize_text("Music", beautiful.fg_normal))
		end
	end
)

return music
