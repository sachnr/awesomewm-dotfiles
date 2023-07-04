local pallete = require("theme.pallete")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helper = require("helper")

local widget = wibox.widget({
    {
        id = "tx_speed",
        markup = string.format(
            "<span font='%s 10' color='%s'>  </span><span font='%s bold 10' color='%s'>%s</span>",
            beautiful.icon_fonts,
            beautiful.accent,
            beautiful.font_alt,
            pallete.foreground,
            0
        ),
        widget = wibox.widget.textbox,
    },
    helper.padding_h(dpi(4)),
    {
        id = "rx_speed",
        markup = string.format(
            "<span font='%s 10' color='%s'>  </span><span font='%s bold 10' color='%s'>%s</span>",
            beautiful.icon_fonts,
            beautiful.accent,
            beautiful.font_alt,
            pallete.foreground,
            0
        ),
        widget = wibox.widget.textbox,
    },
    layout = wibox.layout.align.horizontal,
})

local function convert_to_closest(bytes)
    local speed
    local dim
    local bits = bytes * 8
    if bits < 1000 then
        speed = bits
        dim = "b/s"
    elseif bits < 1000000 then
        speed = bits / 1000
        dim = "kb/s"
    elseif bits < 1000000000 then
        speed = bits / 1000000
        dim = "mb/s"
    elseif bits < 1000000000000 then
        speed = bits / 1000000000
        dim = "gb/s"
    else
        speed = tonumber(bits)
        dim = "b/s"
    end
    return math.floor(speed + 0.5) .. dim
end

local function split(string_to_split, separator)
    if separator == nil then separator = "%s" end
    local t = {}

    for str in string.gmatch(string_to_split, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end

    return t
end

local prev_rx = 0
local prev_tx = 0
local timeout = 1

local update_widget = function(widget, stdout)
    local cur_vals = split(stdout, "\r\n")

    local cur_rx = 0
    local cur_tx = 0

    for i, v in ipairs(cur_vals) do
        if i % 2 == 1 then cur_rx = cur_rx + v end
        if i % 2 == 0 then cur_tx = cur_tx + v end
    end

    local speed_rx = (cur_rx - prev_rx) / timeout
    local speed_tx = (cur_tx - prev_tx) / timeout

    local speed_rx_markup = string.format(
        "<span font='%s 10' color='%s'>  </span><span font='%s bold 10' color='%s'>%s</span>",
        beautiful.icon_fonts,
        beautiful.accent,
        beautiful.font_alt,
        pallete.foreground,
        convert_to_closest(speed_rx)
    )
    local speed_tx_markup = string.format(
        "<span font='%s 10' color='%s'>  </span><span font='%s bold 10' color='%s'>%s</span>",
        beautiful.icon_fonts,
        beautiful.accent,
        beautiful.font_alt,
        pallete.foreground,
        convert_to_closest(speed_tx)
    )

    widget.rx_speed:set_markup(speed_rx_markup)
    widget.tx_speed:set_markup(speed_tx_markup)

    prev_rx = cur_rx
    prev_tx = cur_tx
end

awful.widget.watch(
    string.format([[bash -c "cat /sys/class/net/%s/statistics/*_bytes"]], "*"),
    timeout,
    update_widget,
    widget
)

local M = {}

M.default = function()
    local widget_boxed = helper.box_widget({
        widget = widget,
        bg_color = beautiful.module_bg,
        margins = dpi(6),
    })

    helper.hover({
        widget = widget_boxed:get_children_by_id("box_container")[1],
        oldbg = beautiful.module_bg,
        newbg = beautiful.module_bg_focused,
    })

    return widget_boxed
end

--- box a widget
---@param args {bg_color: string, forced_width: number, forced_height: number, shape: function, margins: number, horizontal_padding: number}
---@return table
M.setup = function(args)
    local widget_boxed = helper.box_widget({
        widget = widget,
        bg_color = args.bg_color or beautiful.module_bg,
        margins = args.margins or dpi(6),
        forced_height = args.forced_height or nil,
        forced_width = args.forced_width or nil,
        horizontal_padding = args.horizontal_padding or dpi(6),
        shape = args.shape or helper.rounded_rect(dpi(4)),
    })

    helper.hover({
        widget = widget_boxed:get_children_by_id("box_container")[1],
        oldbg = beautiful.module_bg,
        newbg = beautiful.module_bg_focused,
    })

    return widget_boxed
end

return M
