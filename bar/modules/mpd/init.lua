require("bar.modules.mpd.mpc_signal")
local awful = require("awful")
local wibox = require("wibox.init")
local pallete = require("theme.pallete")
local helper = require("helper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local widget = wibox.widget({
    {
        id = "text",
        font = beautiful.font_alt .. " Bold 10",
        markup = helper.color_text("   offline", pallete.brightblue),
        widget = wibox.widget.textbox,
    },
    nil,
    nil,
    layout = wibox.layout.align.horizontal,
})

local widget_boxed = helper.box_widget({
    widget = widget,
    bg_color = pallete.background2,
    margins = dpi(6),
})

helper.hover({
    widget = widget_boxed:get_children_by_id("box_container")[1],
    newbg = pallete.background3,
    oldbg = pallete.background2,
})

---@diagnostic disable-next-line: undefined-global
awesome.connect_signal("mpd::status", function(t)
    setmetatable(t, { __index = { title = "offline" } })
    local title = string.format(
        " <span foreground='%s'></span>  <span foreground='%s'>%s</span> ",
        pallete.brightblue,
        pallete.foreground,
        t.title
    )
    widget.text:set_markup(title)
end)

return widget_boxed
