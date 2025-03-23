local wibox = require("wibox.init")
local beautiful = require("beautiful")
local helper = require("helper")
local awful = require("awful")

local M = {}

local timeout = 2

M.icons = {
	prev = "󰒮",
	play = "󰐊",
	pause = "󰏤",
	next = "󰒭",
	stop = "",
}

local function mpd_update()
	local list = {
		M.icons[mpd_now.state],
		mpd_now.title,
	}
	local text = table.concat(list, " ")
	M.widget.markup = string.format(
		"<span font='%s %s' color='%s'> %s </span>",
		beautiful.font,
		beautiful.font_size,
		beautiful.fg_normal,
		text
	)
end

M.widget = wibox.widget({
	markup = string.format(
		"<span font='%s %s' color='%s'> Now Playing </span>",
		beautiful.font,
		beautiful.font_size,
		beautiful.fg_normal
	),
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

M.setup = function()
	helper.newtimer("Mpd Status Text", timeout, mpd_update, true, true)

	M.widget:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			awful.spawn("mpc toggle")
		end
		if button == 3 then
			awful.spawn("ghostty -e ncmpcpp")
		end
	end)

	return M.widget
end

return M
