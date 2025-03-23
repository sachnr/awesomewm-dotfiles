local wibox = require("wibox.init")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helper = require("helper")

local M = {}

local timeout = 2

M.icons = {
	crit = "",
	low = "",
	med = "",
	high = "",
	full = "",
}

local function battery_update()
	local icon = M.icons.full
	if bat_now.perc <= 20 then
		icon = M.icons.crit
	elseif bat_now.perc <= 40 then
		icon = M.icons.low
	elseif bat_now.perc <= 60 then
		icon = M.icons.med
	elseif bat_now.perc <= 80 then
		icon = M.icons.high
	elseif bat_now.perc <= 100 then
		icon = M.icons.full
	end

	local color = beautiful.fg_normal
	if bat_now.status == "Charging" then
		color = beautiful.bg_success
	elseif bat_now.status == "Discharging" then
		color = beautiful.bg_warning
	elseif bat_now.status == "Full" then
		color = beautiful.fg_normal
	end

	local list = {
		bat_now.perc,
		"%",
		" ",
	}
	local text = table.concat(list, " ")

	M.widget.markup = string.format(
		"<span font='%s %s' color='%s'>  " .. icon .. " %s </span>",
		beautiful.font,
		beautiful.font_size,
		color,
		text
	)
end

M.widget = wibox.widget({
	markup = string.format(
		"<span font='%s %s' color='%s'>  </span>",
		beautiful.font,
		beautiful.font_size,
		beautiful.fg_normal
	),
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

M.setup = function()
	helper.newtimer("Battery Status Text", timeout, battery_update, true, true)

	return helper.create_rounded_widget(M.widget, dpi(12))
end

return M
