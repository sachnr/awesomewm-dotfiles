local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local pallete = require("theme.pallete")
local helpers = require("helper")
local widget = require("bar.modules.mpd.popup.popupwidget")

local M = {}

M.setup = function(s, style)
	local music_panel = awful.popup({
		ontop = true,
		screen = s,
		visible = false,
		type = "dock",
		bg = pallete.black,
		fg = pallete.foreground,
		shape = helpers.rounded_rect(dpi(4)),
		placement = function(w)
			if style == "vertical" then
				awful.placement.top_right(w, {
					margins = { bottom = dpi(5), top = dpi(100), left = dpi(5), right = dpi(50) },
				})
			else
				awful.placement.top(w, {
					margins = { bottom = dpi(5), top = dpi(40), left = dpi(5), right = dpi(5) },
				})
			end
		end,
		widget = {
			{
				{
					-- widget goes here
					widget,
					spacing = dpi(20),
					layout = wibox.layout.fixed.vertical,
					widget = wibox.container.margin,
				},
				margins = dpi(16),
				widget = wibox.container.margin,
			},
			shape = helpers.rounded_rect(dpi(12)),
			bg = pallete.black,
			widget = wibox.container.background,
		},
		layout = wibox.layout.align.vertical,
	})

	music_panel.opened = false
	---@diagnostic disable-next-line: undefined-global
	awesome.connect_signal("music::toggle", function(scr)
		if scr == s then
			s.music_panel.visible = not s.music_panel.visible
		end
	end)
	---@diagnostic disable-next-line: undefined-global
	awesome.connect_signal("music::close", function(scr)
		if scr == s then
			s.music_panel.visible = false
		end
	end)

	return music_panel
end

return M
