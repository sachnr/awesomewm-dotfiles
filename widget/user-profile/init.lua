local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("client.helpers")
local gears = require("gears")
local mat_icon_button_rect = require("widget.icon-button.icon-button-rect")
local mat_icon = require("widget.icon-button.icon")
local icons = require("icons.flaticons")

-- ------ Box Widget ---------

local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
	local box_container = wibox.container.background()
	box_container.bg = bg_color
	box_container.forced_height = height
	box_container.forced_width = width
	box_container.shape = helpers.rrect(dpi(12))

	local boxed_widget =
		wibox.widget(
		{
			--- Add margins
			{
				--- Add background color
				{
					--- The actual widget goes here
					widget_to_be_boxed,
					top = dpi(10),
					bottom = dpi(10),
					left = dpi(10),
					right = dpi(10),
					widget = wibox.container.margin
				},
				widget = box_container
			},
			margins = dpi(10),
			color = "#FF000000",
			widget = wibox.container.margin
		}
	)

	return boxed_widget
end

-- -- User Profile Widget ----

local function widget()
	local icon =
		wibox.widget(
		{
			{
				font = beautiful.icon_fonts,
				markup = helpers.colorize_text("", beautiful.bg_normal),
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox
			},
			bg = beautiful.accent_normal,
			widget = wibox.container.background,
			shape = gears.shape.circle,
			forced_height = dpi(20),
			forced_width = dpi(20)
		}
	)

	local image =
		wibox.widget(
		{
			{
				{
					{
						image = beautiful.pfp,
						resize = true,
						clip_shape = gears.shape.circle,
						halign = "center",
						valign = "center",
						widget = wibox.widget.imagebox
					},
					border_width = dpi(2),
					border_color = beautiful.accent_normal,
					shape = gears.shape.circle,
					widget = wibox.container.background
				},
				strategy = "exact",
				height = dpi(60),
				width = dpi(60),
				widget = wibox.container.constraint
			},
			{
				nil,
				nil,
				{
					nil,
					nil,
					icon,
					layout = wibox.layout.align.horizontal,
					expand = "none"
				},
				layout = wibox.layout.align.vertical,
				expand = "none"
			},
			layout = wibox.layout.stack
		}
	)

	--- username
	local profile_name =
		wibox.widget(
		{
			widget = wibox.widget.textbox,
			markup = "N/A",
			font = beautiful.monospace_bold,
			valign = "center"
		}
	)

	awful.spawn.easy_async_with_shell(
		[[
	sh -c '
	fullname="$(getent passwd `whoami` | cut -d ':' -f 1)"
	printf "$fullname"
	'
	]],
		function(stdout)
			local stdout = stdout:gsub("%\n", "")
			profile_name:set_markup(stdout)
		end
	)

	--- uptime
	local uptime_time =
		wibox.widget(
		{
			widget = wibox.widget.textbox,
			markup = "0 minutes",
			font = beautiful.monospace,
			valign = "center"
		}
	)

	local update_uptime = function()
		awful.spawn.easy_async_with_shell(
			"uptime -p | sed 's/up//;s/hours/H/;s/minutes/M/;s/,//'",
			function(stdout)
				local uptime = stdout:gsub("%\n", "")
				uptime_time:set_markup(uptime)
			end
		)
	end

	gears.timer(
		{
			timeout = 60,
			autostart = true,
			call_now = true,
			callback = function()
				update_uptime()
			end
		}
	)
	-- init buttons
	local lock_screen = mat_icon_button_rect(mat_icon(icons.lock, dpi(24)))
	local sleep = mat_icon_button_rect(mat_icon(icons.sleep, dpi(24)))
	local restart = mat_icon_button_rect(mat_icon(icons.restart, dpi(24)))
	local shut_down = mat_icon_button_rect(mat_icon(icons.power, dpi(24)))
	helpers.bmaker(lock_screen, apps.lock)
	helpers.bmaker(sleep, "systemctl suspend")
	helpers.bmaker(restart, "reboot")
	helpers.bmaker(shut_down, "poweroff")
	--init widget
	local profile =
		wibox.widget(
		{
			{
				image,
				{
					nil,
					{
						{
							widget = wibox.container.margin,
							profile_name
						},
						{
							widget = wibox.container.margin,
							uptime_time
						},
						forced_width = dpi(80),
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(2)
					},
					layout = wibox.layout.align.vertical,
					expand = "none"
				},
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(15)
			},
			{
				nil,
				nil,
				{
					lock_screen,
					sleep,
					restart,
					shut_down,
					spacing = dpi(6),
					layout = wibox.layout.fixed.horizontal
				},
				layout = wibox.layout.align.horizontal
			},
			layout = wibox.layout.align.vertical
		}
	)

	return profile
end

return create_boxed_widget(widget(), dpi(270), dpi(120), beautiful.widget_bg_normal)
