local awful = require("awful")
local wibox = require("wibox.init")
local gears = require("gears")
local beautiful = require("beautiful")
local helper = require("helper")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")

local M = {}

M.widget = wibox.widget({
	{
		id = "volume_icon",
		markup = string.format("<span color='%s'>󰕾</span>", beautiful.accent),
		widget = wibox.widget.textbox,
	},
	{
		id = "volume_slider",
		forced_height = dpi(1),
		forced_width = dpi(59),
		color = beautiful.accent,
		background_color = beautiful.module_bg,
		margins = dpi(2),
		paddings = dpi(2),
		max_value = 150,
		ticks = true,
		ticks_size = dpi(6),
		shape = gears.shape.rounded_bar,
		widget = wibox.widget.progressbar,
	},
	{
		id = "volume_text",
		markup = string.format(
			"<span font='%s %s' color='%s'> 0%% </span>",
			beautiful.font,
			beautiful.font_size,
			beautiful.fg_normal
		),
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	},
	forced_width = dpi(148),
	layout = wibox.layout.align.horizontal,
})

local icons = {
	muted = " 󰝟 ",
	low = " 󰕿 ",
	med = " 󰖀 ",
	high = " 󰕾 ",
}

local critical_bar_color = {
	type = "linear",
	from = { 0, 0 },
	to = { 96, 0 },
	stops = {
		{ 0, beautiful.accent },
		{ 1, beautiful.bg_urgent },
	},
}

local debounce_timer = nil

local function set_volume_debounced(volume)
	if debounce_timer then
		debounce_timer:stop()
	end

	debounce_timer = gears.timer.start_new(0.2, function()
		awful.spawn("wpctl set-volume @DEFAULT_SINK@ " .. volume)
	end)
end

local function update_volume_sys_event(icon, volume)
	M.widget.volume_icon:set_markup(string.format("<span color='%s'>" .. icon .. "</span>", beautiful.accent))
	M.widget.volume_text.markup = string.format(
		"<span font='%s %s' color='%s'> " .. volume .. "%% </span>",
		beautiful.font,
		beautiful.font_size,
		beautiful.fg_normal
	)
	M.widget.volume_slider:set_value(volume)
	if volume > 100 then
		M.widget.volume_slider.color = critical_bar_color
	else
		M.widget.volume_slider.color = beautiful.accent
	end
end

local function sync_volume_changes()
	awful.spawn.easy_async("wpctl get-volume @DEFAULT_SINK@", function(stdout)
		local icon
		local volume = tonumber(stdout:match("(%d%.%d%d?)")) * 100
		if stdout:match("MUTED") then
			icon = icons.muted
			update_volume_sys_event(icon, volume)
			return
		end
		if volume < 50 then
			icon = icons.low
		elseif volume < 90 then
			icon = icons.med
		else
			icon = icons.high
		end

		update_volume_sys_event(icon, volume)
	end)
end

M.setup = function()
	-- kill process if pactl subscribe is already running
	awful.spawn.easy_async_with_shell(
		"ps x | grep 'pactl subscribe' | grep -v grep | awk '{print $1}' | xargs kill",
		function()
			-- start new one with callback
			awful.spawn.with_line_callback(
				[[bash -c "pactl subscribe | grep --line-buffered \"Event 'change' on sink #\""]],
				{
					stdout = function(_)
						sync_volume_changes()
					end,
				}
			)
		end
	)

	M.widget.volume_slider:connect_signal("property::value", function()
		set_volume_debounced(M.widget.volume_slider.value / 100)
	end)

	M.widget.volume_slider:connect_signal("button::press", function(_, _, _, button)
		if button == 4 then
			awful.spawn("wpctl set-volume @DEFAULT_SINK@ 5%+")
		end
		if button == 5 then
			awful.spawn("wpctl set-volume @DEFAULT_SINK@ 5%-")
		end
	end)

	M.widget.volume_icon:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			awful.spawn("wpctl set-mute @DEFAULT_SINK@ toggle")
		end
		if button == 3 then
			awful.spawn("pavucontrol-qt")
		end
	end)

	helper.hover_hand(M.widget.volume_icon)
	helper.hover_hand(M.widget.volume_slider)

	sync_volume_changes()

	return helper.create_rounded_widget(M.widget, dpi(12))
end

return M
