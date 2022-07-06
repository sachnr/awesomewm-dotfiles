-- =========================================================
-- ===================== Search Box ========================
-- =========================================================

local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("client.helpers")
local gears = require("gears")

--- Header
    local function search_box()
        local search_icon = wibox.widget({
            font = "icomoon bold 12",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox(),
        })

        local reset_search_icon = function()
            search_icon.markup = helpers.colorize_text("", beautiful.accent_normal)
        end
        reset_search_icon()

        local search_text = wibox.widget({
            --- markup = helpers.ui.colorize_text("Search", beautiful.xcolor8),
            align = "center",
            valign = "center",
            font = beautiful.monospace,
            widget = wibox.widget.textbox(),
        })

        local search = wibox.widget({
            {
                {
                    search_icon,
                    {
                        search_text,
                        bottom = dpi(2),
                        widget = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = dpi(15),
                widget = wibox.container.margin,
            },
            forced_height = dpi(35),
            forced_width = dpi(420),
            shape = gears.shape.rounded_bar,
            bg = beautiful.bg_normal,
            widget = wibox.container.background(),
        })
        helpers.add_hover_cursor(search, "hand1")
        local function generate_prompt_icon(icon, color)
            return "<span font='icomoon 12' foreground='" .. color .. "'>" .. icon .. "</span> "
        end

        local function activate_prompt(action)
            search_icon.visible = false
            local prompt
            if action == "run" then
                prompt = generate_prompt_icon("", beautiful.accent_normal)
            elseif action == "web_search" then
                prompt = generate_prompt_icon("", beautiful.accent_normal)
            end
            helpers.prompt(action, search_text, prompt, function()
                search_icon.visible = true
            end)
        end

        search:buttons(gears.table.join(
            awful.button({}, 1, function()
                activate_prompt("run")
            end),
            awful.button({}, 3, function()
                activate_prompt("web_search")
            end)
        ))

        return search
    end

    local Box = wibox.widget(
        {
            {
                wibox.widget({
                    markup = helpers.colorize_text("Dashboard ", beautiful.fg_normal),
                    font = beautiful.title_fonts,
                    valign = "center",
                    widget = wibox.widget.textbox,
                }),
                nil,
                search_box(),
                layout = wibox.layout.align.horizontal
            },
            margins = dpi(10),
            widget = wibox.container.margin
        }
    )

 return helpers.create_boxed_widget((Box), dpi(580), dpi(45), beautiful.widget_bg_normal)