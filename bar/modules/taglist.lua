local awful = require("awful")
local fancy_taglist = require("external.fancy_taglist")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helper = require("helper")

local M = {}

local tag_buttons = {
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewprev(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewnext(t.screen)
	end),
}

local tasklist_buttons = {
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "tasklist", { raise = true, switch_to_tags = true })
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end),
}

M.setup = function(s)
	s.mytaglist = fancy_taglist.new({
		screen = s,
		taglist = { buttons = tag_buttons },
		tasklist = { buttons = tasklist_buttons },
	})

	local rounded_widget = helper.create_rounded_widget(s.mytaglist, dpi(12))

	return rounded_widget
end

return M
