local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("client.helpers")
local dpi = beautiful.xresources.apply_dpi

local styles = {}

styles.month = {
    padding = dpi(4),
    bg_color = beautiful.bg0,
    shape = helpers.rrect(dpi(6)),
    widget = wibox.container.margin
}

styles.normal = {
    fg_color = beautiful.fg_normal,
    bg_color = beautiful.widget_bg_normal,
    shape = helpers.rrect(dpi(4))
}

styles.focus = {
    fg_color = beautiful.cal_focus_fg,
    bg_color = beautiful.cal_focus_bg,
    markup = function(t)
        return "<b>" .. t .. "</b>"
    end,
    shape = helpers.rrect(dpi(4)),
    align = "center"
}

styles.header = {
    fg_color = beautiful.cal_header_fg,
    bg_color = beautiful.cal_header_bg,
    shape = helpers.rrect(dpi(6)),
    markup = function(t)
        return "<b>" .. t .. "</b>"
    end
}

styles.weekday = {
    fg_color = beautiful.cal_week_fg,
    bg_color = beautiful.cal_week_bg,
    shape = helpers.rrect(dpi(4)),
    markup = function(t)
        return "<b>" .. t .. "</b>"
    end
}

local decorate_cell = function(widget, flag, date)
    if flag == "monthheader" and not styles.monthheader then
        flag = "header"
    end
    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = {
        year = date.year,
        month = (date.month or 1),
        day = (date.day or 1)
    }
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_bg = beautiful.widget_bg_normal
    local ret = wibox.widget {
        {
            {
                widget,
                halign = "center",
                widget = wibox.container.place
            },
            margins = (props.padding or 2) + (props.border_width or 0),
            widget = wibox.container.margin
        },
        shape = props.shape,
        shape_border_color = props.border_color or "#b9214f",
        shape_border_width = props.border_width or 0,
        fg = props.fg_color or "#999999",
        bg = props.bg_color or default_bg,
        widget = wibox.container.background
    }
    return ret
end

local calendar = wibox.widget {
    font = beautiful.normal_fonts,
    date = os.date("*t"),
    spacing = dpi(9),
    start_sunday = true,
    long_weekdays = false,
    fn_embed = decorate_cell,
    widget = wibox.widget.calendar.month
}

local current_month = calendar:get_date().month

local update_focus_bg = function(month)
    if current_month == month then
        styles.focus.bg_color = beautiful.accent_normal
        styles.focus.markup = function(t)
            return "<b>" .. t .. "</b>"
        end
    else
        styles.focus.bg_color = beautiful.transparent
        styles.focus.markup = function(t)
            return t
        end
    end
end

local update_active_month = function(i)
    local date = calendar:get_date()
    date.month = date.month + i
    update_focus_bg(date.month)
    calendar:set_date(nil)
    calendar:set_date(date)
end

calendar:buttons(gears.table.join(awful.button({}, 4, function()
    update_active_month(-1)
end), awful.button({}, 5, function()
    update_active_month(1)
end)))
return wibox.container.margin(calendar, dpi(6), dpi(6), dpi(6), dpi(6))
