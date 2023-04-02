-- default template
local awful = require("awful.init")
local helper = require("helper")
local dpi = require("beautiful").xresources.apply_dpi
local pallete = require("theme.pallete")

local function taglist(s)
    local mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
    })

    local taglist_boxed = helper.box_widget({
        widget = mytaglist,
        bg_color = pallete.background2,
        margins = dpi(6),
        width = dpi(200),
    })

    helper.hover_hand(taglist_boxed)

    return taglist_boxed
end
return taglist
