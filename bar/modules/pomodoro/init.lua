local wibox = require("wibox.init")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local gears = require("gears")
local helper = require("helper")
local pallete = require("theme.pallete")

local M = {}

M.setup = function(style)
	local markup
	if style == "vertical" then
		markup =
			string.format("<span font='%s 10 Bold' color='%s'>25\n00</span>", beautiful.font_alt, beautiful.fg_normal)
	else
		markup = string.format(
			"<span font='%s 11' color='%s'>  </span><span font='%s bold 10.2' color='%s'> 25:00 </span>",
			beautiful.icon_font,
			beautiful.accent,
			beautiful.font_alt,
			pallete.foreground
		)
	end

	local widget = wibox.widget({
		markup = markup,
		halign = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local timer_running = false
	local remaining_time = 25 * 60
	local text_color = pallete.brightblue
	local break_started = false

	local timer = gears.timer({
		timeout = 1,
		autostart = true,
		call_now = false,
	})

	local function update_timer()
		local minutes = math.floor(remaining_time / 60)
		local seconds = remaining_time % 60

		if style == "vertical" then
			widget:set_markup(
				string.format(
					"<span font='%s 10 Bold' color='%s'>%02d\n%02d</span>",
					beautiful.font_alt,
					text_color,
					minutes,
					seconds
				)
			)
		else
			widget:set_markup(
				string.format(
					"<span font='%s 11' color='%s'>  </span><span font='%s bold 10.2' color='%s'> %02d:%02d </span>",
					beautiful.icon_font,
					text_color,
					beautiful.font_alt,
					pallete.foreground,
					minutes,
					seconds
				)
			)
		end

		remaining_time = remaining_time - 1
		if remaining_time < 0 then
			timer:stop()
			naughty.notify({ title = "Pomodoro", text = "Time's up!", timeout = 5 })
			if not break_started then
				remaining_time = 5 * 60
				text_color = pallete.brightgreen
				timer:start()
				break_started = true
			end
		end
	end

	local pomo_boxed = helper.box_widget({
		widget = widget,
		bg_color = beautiful.module_bg,
		margins = dpi(6),
	})

	helper.hover({
		widget = pomo_boxed:get_children_by_id("box_container")[1],
		oldbg = beautiful.module_bg,
		newbg = beautiful.module_bg_focused,
	})

	pomo_boxed:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			if timer_running then
				local markup_stopped
				if style == "vertical" then
					markup_stopped = string.format(
						"<span font='%s 10 Bold' color='%s'>25\n00</span>",
						beautiful.font_alt,
						beautiful.fg_normal
					)
				else
					markup_stopped = string.format(
						"<span font='%s 11' color='%s'>  </span><span font='%s bold 10.2' color='%s'> 25:00 </span>",
						beautiful.icon_font,
						beautiful.accent,
						beautiful.font_alt,
						pallete.foreground
					)
				end
				widget:set_markup(markup_stopped)
				timer:stop()
				timer_running = false
			else
				remaining_time = 25 * 60
				text_color = pallete.brightblue
				timer = gears.timer({
					timeout = 1,
					autostart = true,
					call_now = true,
					callback = function()
						update_timer()
					end,
				})
				timer_running = true
			end
		end
	end)

	return pomo_boxed
end

return M
