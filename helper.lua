local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local M = {}
local helpers = {}
helpers.map_table = {}

--- adds hover properties to a background container
--- to add hover to box_widget use 'widget:get_children_by_id("box_container")\[1\]' as widget name
---@param t {widget: table, newbg: string, oldbg: string, hover_cursor: string}
M.hover = function(t)
	setmetatable(t, { __index = { hover_cursor = "hand1" } })
	local widget = t.widget
	local newbg = t.newbg
	local oldbg = t.oldbg
	local hover_cursor = t.hover_cursor
	widget:connect_signal("mouse::enter", function()
		widget:set_bg(newbg)
		---@diagnostic disable-next-line: undefined-global
		local w = mouse.current_wibox
		if w then
			w.cursor = hover_cursor
		end
	end)
	widget:connect_signal("mouse::leave", function()
		widget:set_bg(oldbg)
		---@diagnostic disable-next-line: undefined-global
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
	end)
end

--- same as hover but dosent change the background
---@see M.hover
---@param widget table
M.hover_hand = function(widget)
	widget:connect_signal("mouse::enter", function()
		---@diagnostic disable-next-line: undefined-global
		local w = mouse.current_wibox
		if w then
			w.cursor = "hand1"
		end
	end)
	widget:connect_signal("mouse::leave", function()
		---@diagnostic disable-next-line: undefined-global
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
	end)
end

M.create_rounded_widget = function(widget, amount)
	local container = wibox.container.background()
	container.bg = beautiful.module_bg
	container.shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, amount)
	end
	container.id = "container"

	container.widget = widget

	-- lrtb
	return wibox.container.margin(container, dpi(8), dpi(8), dpi(4), dpi(4))
end

M.set_map = function(element, value)
	helpers.map_table[element] = value
end

M.get_map = function(element)
	return helpers.map_table[element]
end

M.async = function(cmd, callback)
	return awful.spawn.easy_async(cmd, function(stdout, _, _, exit_code)
		callback(stdout, exit_code)
	end)
end

M.newtimer = function(name, timeout, fun, nostart, stoppable)
	if not name or #name == 0 then
		return
	end
	local key = stoppable and name or timeout
	helpers.timer_table = helpers.timer_table or {}
	if not helpers.timer_table[key] then
		helpers.timer_table[key] = gears.timer({ timeout = timeout })
		helpers.timer_table[key]:start()
	end
	helpers.timer_table[key]:connect_signal("timeout", fun)
	if not nostart then
		helpers.timer_table[key]:emit_signal("timeout")
	end
	return stoppable and helpers.timer_table[key]
end

M.first_line = function(path)
	local file, first = io.open(path, "rb"), nil
	if file then
		first = file:read("*l")
		file:close()
	end
	return first
end

M.line_callback = function(cmd, callback)
	return awful.spawn.with_line_callback(cmd, {
		stdout = function(line)
			callback(line)
		end,
	})
end

return M
