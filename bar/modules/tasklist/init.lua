-- default template
local awful = require("awful.init")
local helper = require("helper")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tasklist = function(s)
    local mytasklist = awful.widget.tasklist({
        screen = s,
        -- filter = awful.widget.tasklist.filter.currenttags,
        filter = awful.widget.tasklist.source.all_clients,
        buttons = {
            awful.button({}, 1, function(c)
                -- if c == client.focus then
                -- c.minimized = true
                -- else
                c:emit_signal("request::activate", "tasklist", { raise = true, switch_to_tags = true })
                -- end
            end),
            awful.button({}, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
            awful.button({}, 4, function() awful.client.focus.byidx(1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(-1) end),
        },
        layout = {
            spacing_widget = {
                {
                    forced_width = dpi(5),
                    forced_height = dpi(24),
                    thickness = dpi(1),
                    color = "#00000000",
                    widget = wibox.widget.separator,
                },
                valign = "center",
                halign = "center",
                widget = wibox.container.place,
            },
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal,
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            nil,
            {
                {
                    id = "clienticon",
                    widget = awful.widget.clienticon,
                },
                margins = dpi(5),
                widget = wibox.container.margin,
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id("clienticon")[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    })

    local mytasklist_boxed = helper.box_widget({
        widget = mytasklist,
        bg_color = beautiful.module_bg,
        margins = dpi(4),
    })

    helper.hover_hand(mytasklist_boxed)

    return mytasklist_boxed
end
return tasklist
