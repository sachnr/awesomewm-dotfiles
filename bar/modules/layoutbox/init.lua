local awful = require("awful")
local helper = require("helper")
local dpi = require("beautiful").xresources.apply_dpi
local pallete = require("theme.pallete")

local function layout(s)
    local mylayoutbox = awful.widget.layoutbox({
        screen = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        },
    })

    local layoutbox_boxed = helper.box_widget({
        widget = mylayoutbox,
        bg_color = pallete.background2,
        margins = dpi(6),
    })

    helper.hover({
        widget = layoutbox_boxed:get_children_by_id("box_container")[1],
        oldbg = pallete.background,
        newbg = pallete.background2,
    })

    return layoutbox_boxed
end

return layout
