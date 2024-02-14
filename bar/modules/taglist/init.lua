-- default template
local awful = require("awful.init")
local helper = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

local function taglist(s, style)
	local layout
	if style == "vertical" then
		layout = wibox.layout.fixed.vertical
		beautiful.taglist_spacing = dpi(10)
	else
		layout = wibox.layout.fixed.horizontal
	end

	local mytaglist = awful.widget.taglist({
		screen = s,
		layout = layout,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})

	local taglist_boxed = helper.box_widget({
		widget = mytaglist,
		bg_color = beautiful.module_bg,
		margins = dpi(6),
	})

	helper.hover_hand(taglist_boxed)

	return taglist_boxed
end
return taglist
