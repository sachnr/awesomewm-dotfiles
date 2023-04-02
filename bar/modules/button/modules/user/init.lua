local wibox = require("wibox")
local helpers = require("helper")
local gears = require("gears")
local pallete = require("theme.pallete")
local beautiful = require("beautiful")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi

local icon = wibox.widget({
    {
        id = "icon",
        markup = helpers.color_text_icon("", pallete.brightblue, "11"),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    },
    nil,
    nil,
    bg = pallete.background,
    shape = gears.shape.circle,
    forced_height = dpi(20),
    forced_width = dpi(20),
    widget = wibox.container.background,
    layout = wibox.layout.align.horizontal,
})

local user_image = wibox.widget({
    {
        {
            {
                image = beautiful.pfp,
                resize = true,
                clip_shape = gears.shape.circle,
                halign = "center",
                valign = "center",
                widget = wibox.widget.imagebox,
            },
            border_width = dpi(2),
            border_color = pallete.brightblack,
            shape = gears.shape.circle,
            widget = wibox.container.background,
        },
        strategy = "exact",
        height = dpi(100),
        width = dpi(100),
        widget = wibox.container.constraint,
    },
    {
        nil,
        nil,
        {
            nil,
            nil,
            icon,
            layout = wibox.layout.align.horizontal,
            expand = "none",
        },
        layout = wibox.layout.align.vertical,
        expand = "none",
    },
    layout = wibox.layout.stack,
})

local user_name = wibox.widget({
    widget = wibox.widget.textbox,
    ---@diagnostic disable-next-line: param-type-mismatch
    markup = helpers.color_text(os.getenv("USER"), pallete.brightblue),
    font = beautiful.font_alt .. " 12",
    valign = "center",
})

local uptime = wibox.widget({
    widget = wibox.widget.textbox,
    font = beautiful.font_alt .. " 10",
    valign = "center",
})

local update_uptime = function()
    awful.spawn.easy_async_with_shell(
        "uptime | awk '{print $3}' | sed 's/,//;s/:/H /;s/$/M/'",
        function(stdout) uptime:set_markup(stdout:gsub("%\n", "")) end
    )
end

gears.timer({
    timeout = 60,
    autostart = true,
    call_now = true,
    callback = function() update_uptime() end,
})

local tasks = {
    -- lock = "i3lock",
    sleep = "systemctl suspend",
    quit = 'echo "awesome.quit()" | awesome-client',
    restart = "systemctl reboot",
    poweroff = "systemctl poweroff",
}

local icons = {
    -- lock = "  ",
    sleep = "  ",
    quit = "  ",
    restart = "  ",
    poweroff = " 襤 ",
}

local power_widgets = {}

for key, value in pairs(tasks) do
    local widget = wibox.widget({
        {
            id = "icon",
            markup = helpers.color_text_icon(icons[key], pallete.brightblue, " 11"),
            widget = wibox.widget.textbox,
        },
        nil,
        nil,
        forced_height = dpi(30),
        forced_width = dpi(28),
        layout = wibox.layout.align.horizontal,
    })

    power_widgets[key] = helpers.box_widget({
        widget = widget,
        bg_color = pallete.background2,
        margins = dpi(6),
    })

    helpers.hover({
        widget = power_widgets[key]:get_children_by_id("box_container")[1],
        newbg = pallete.background3,
        oldbg = pallete.background2,
    })

    power_widgets[key]:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            awful.spawn.with_shell(value)
            ---@diagnostic disable-next-line: undefined-global
            awesome.emit_signal("dashboard::close", awful.screen.focused())
        end
    end)
end

local profile = wibox.widget({
    {
        user_image,
        {
            nil,
            {
                {
                    widget = wibox.container.margin,
                    user_name,
                },
                {
                    widget = wibox.container.margin,
                    uptime,
                },
                forced_width = dpi(80),
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(2),
            },
            layout = wibox.layout.align.vertical,
            expand = "none",
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(15),
    },
    {
        nil,
        nil,
        {
            power_widgets.sleep,
            power_widgets.quit,
            power_widgets.restart,
            power_widgets.poweroff,
            spacing = dpi(6),
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal,
    },
    layout = wibox.layout.align.vertical,
})

local boxed_profile = helpers.box_widget({
    widget = profile,
    bg_color = pallete.background,
    shape = helpers.rounded_rect(dpi(8)),
    margin = dpi(6),
})

return boxed_profile
