local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helper")
local pallete = require("theme.pallete")
local dpi = beautiful.xresources.apply_dpi

local styles = {}

styles.month = {
    padding = dpi(4),
    bg_color = pallete.background,
    shape = helpers.rounded_rect(dpi(6)),
    widget = wibox.container.margin,
}

styles.normal = {
    fg_color = pallete.foreground,
    bg_color = pallete.background,
    shape = helpers.rounded_rect(dpi(4)),
}

styles.focus = {
    fg_color = beautiful.accent,
    bg_color = pallete.background,
    markup = function(t) return "<b>" .. t .. "</b>" end,
    shape = helpers.rounded_rect(dpi(6)),
    align = "center",
}

styles.header = {
    fg_color = beautiful.accent,
    bg_color = pallete.background1,
    shape = helpers.rounded_rect(dpi(6)),
    markup = function(t) return "<b>" .. t .. "</b>" end,
}

styles.weekday = {
    fg_color = beautiful.accent,
    bg_color = pallete.background,
    shape = helpers.rounded_rect(dpi(4)),
    markup = function(t) return "<b>" .. t .. "</b>" end,
}

local decorate_cell = function(widget, flag, date)
    if flag == "monthheader" and not styles.monthheader then flag = "header" end
    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = {
        year = date.year,
        month = (date.month or 1),
        day = (date.day or 1),
    }
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_bg = pallete.background
    local ret = wibox.widget({
        {
            {
                widget,
                halign = "center",
                widget = wibox.container.place,
            },
            margins = (props.padding or 0) + (props.border_width or 0),
            widget = wibox.container.margin,
        },
        shape = props.shape,
        shape_border_color = props.border_color or "#000000",
        shape_border_width = props.border_width or 0,
        fg = props.fg_color or "#ffffff",
        bg = props.bg_color or default_bg,
        widget = wibox.container.background,
    })
    return ret
end

local calendar = wibox.widget({
    font = beautiful.font_alt .. "Bold 10",
    date = os.date("*t"),
    spacing = dpi(9),
    start_sunday = true,
    long_weekdays = false,
    fn_embed = decorate_cell,
    widget = wibox.widget.calendar.month,
})

local current_month = calendar:get_date().month

local update_focus_bg = function(month)
    if current_month == month then
        styles.focus.fg_color = beautiful.accent
        styles.focus.markup = function(t) return "<b>" .. t .. "</b>" end
    else
        styles.focus.bg_color = "#00000000"
        styles.focus.markup = function(t) return t end
    end
end

local update_active_month = function(i)
    local date = calendar:get_date()
    date.month = date.month + i
    update_focus_bg(date.month)
    calendar:set_date(nil)
    calendar:set_date(date)
end

calendar:buttons(
    gears.table.join(
        awful.button({}, 4, function() update_active_month(-1) end),
        awful.button({}, 5, function() update_active_month(1) end)
    )
)
return wibox.container.margin(calendar, dpi(6), dpi(6), dpi(6), dpi(6))
