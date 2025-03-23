local wibox = require("wibox.init")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helper = require("helper")
local awful = require("awful")

local M = {}

local step_amount = 5
local brightness_icon = "󰃟"

M.widget = wibox.widget({
	markup = brightness_icon,
	font = beautiful.icon_font .. " Bold 10",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local function update_widget(_, stdout)
	M.widget.marup = string.format(
		"<span font='%s' color='%s'>" .. brightness_icon .. "</span> <span>" .. stdout .. "</span>",
		beautiful.icon_font,
		beautiful.accent
	)
end

awful.widget.watch("sh -c 'brightnessctl -m | cut -d, -f4 | tr -d %'", 5, update_widget, M.widget)

M.setup = function(opts)
	opts = opts or {}
	if opts.step ~= nil then
		M.step = opts.step
	end

	M.widget:buttons(awful.util.table.join(
		awful.button({}, 4, function()
			awful.spawn("brightnessctl set +" .. step_amount .. "%")
		end),
		awful.button({}, 5, function()
			awful.spawn("brightnessctl set " .. step_amount .. "-%")
		end)
	))

	return helper.create_rounded_widget(M.widget, dpi(12))
end

return M
