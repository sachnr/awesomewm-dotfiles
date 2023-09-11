-- common functions that will be used multiple times

local M = {}
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

--- shape property for widgets
---@param radius integer border radius
M.rounded_rect = function(radius)
    return function(cr, width, height) gears.shape.rounded_rect(cr, width, height, radius) end
end
--- set fg color
---@param text string
---@param color string
---@return string
M.color_text = function(text, color) return string.format("<span foreground='%s'>%s</span>", color, text) end

--- same as color_text but with a different font
---@param text string
---@param color string
---@param size string
---@return string
M.color_text_icon = function(text, color, size)
    return string.format("<span foreground='%s' font='%s %s'>%s</span>", color, beautiful.icon_font, size, text)
end

--- vertical padding
---@param height integer height
---@return table
M.padding_v = function(height)
    return wibox.widget({
        forced_height = height,
        layout = wibox.layout.fixed.vertical,
    })
end

--- horizontal padding
---@param width integer width
---@return table
M.padding_h = function(width)
    return wibox.widget({
        forced_width = width,
        layout = wibox.layout.fixed.vertical,
    })
end

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
        if w then w.cursor = hover_cursor end
    end)
    widget:connect_signal("mouse::leave", function()
        widget:set_bg(oldbg)
        ---@diagnostic disable-next-line: undefined-global
        local w = mouse.current_wibox
        if w then w.cursor = "left_ptr" end
    end)
end

--- same as hover but dosent change the background
---@see M.hover
---@param widget table
M.hover_hand = function(widget)
    widget:connect_signal("mouse::enter", function()
        ---@diagnostic disable-next-line: undefined-global
        local w = mouse.current_wibox
        if w then w.cursor = "hand1" end
    end)
    widget:connect_signal("mouse::leave", function()
        ---@diagnostic disable-next-line: undefined-global
        local w = mouse.current_wibox
        if w then w.cursor = "left_ptr" end
    end)
end

--- box a widget
---@param t {widget: table, bg_color: string, forced_width: number, forced_height: number, shape: function, margins: number, horizontal_padding: number}
---@return table
M.box_widget = function(t)
    setmetatable(t, {
        __index = {
            bg_color = "#000000",
            forced_height = nil,
            forced_width = nil,
            shape = M.rounded_rect(dpi(4)),
            margins = (dpi(2)),
            horizontal_padding = dpi(6),
        },
    })
    local box_container = wibox.container.background()
    box_container.bg = t.bg_color
    box_container.forced_height = t.forced_height
    box_container.forced_width = t.forced_width
    box_container.shape = t.shape
    local boxed_widget = wibox.widget({
        -- Add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed vertically
                nil,
                {
                    -- Center widget_to_be_boxed horizontally
                    M.padding_h(t.horizontal_padding),
                    -- The actual widget goes here
                    t.widget,
                    M.padding_h(t.horizontal_padding),
                    layout = wibox.layout.align.horizontal,
                    expand = "none",
                },
                layout = wibox.layout.align.vertical,
                expand = "none",
            },
            id = "box_container",
            widget = box_container,
        },
        margins = t.margins,
        color = "#00000000",
        widget = wibox.container.margin,
    })

    return boxed_widget
end

return M
