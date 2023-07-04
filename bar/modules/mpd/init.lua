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
        markup = helper.color_text("   offline   ", beautiful.accent),
        widget = wibox.widget.textbox,
    },
    nil,
    nil,
    layout = wibox.layout.align.horizontal,
})

local widget_boxed = helper.box_widget({
    widget = widget,
    bg_color = beautiful.module_bg,
    margins = dpi(6),
})

helper.hover({
    widget = widget_boxed:get_children_by_id("box_container")[1],
    newbg = beautiful.module_bg_focused,
    oldbg = beautiful.module_bg,
})

---@diagnostic disable-next-line: undefined-global
awesome.connect_signal("mpd::status", function(t)
    setmetatable(t, { __index = { title = "offline", artist = "" } })
    local title
    if t.status:match("playing") then
        title = string.format(
            " <span foreground='%s'></span>  <span foreground='%s'>%s - %s</span>  <span foreground='%s'></span> ",
            pallete.brightaqua,
            pallete.foreground,
            t.title,
            t.artist,
            pallete.brightaqua
        )
    else
        title = string.format(
            " <span foreground='%s'></span>  <span foreground='%s'>%s - %s</span>  <span foreground='%s'></span> ",
            beautiful.accent,
            pallete.foreground,
            t.title,
            t.artist,
            beautiful.accent
        )
    end

    widget.text:set_markup(title)
end)

widget_boxed:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal("music::toggle", awful.screen.focused())
    end
end)

return widget_boxed
