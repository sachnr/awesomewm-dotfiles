local wibox = require("wibox")
local helpers = require("helper")
local gears = require("gears")
local pallete = require("theme.pallete")
local beautiful = require("beautiful")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi

local user_image = wibox.widget({
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
    strategy = "max",
    height = dpi(100),
    width = dpi(100),
    widget = wibox.container.constraint,
})

local user_name = wibox.widget({
    widget = wibox.widget.textbox,
    ---@diagnostic disable-next-line: param-type-mismatch
    markup = string.format(
        '<span foreground="%s" font="%s Bold 11"> %s </span>',
        pallete.foreground,
        beautiful.font_alt,
        os.getenv("USER")
    ),
    font = beautiful.font_alt .. " 12",
    valign = "center",
})

local uptime = wibox.widget({
    widget = wibox.widget.textbox,
    font = beautiful.font_alt .. " 10",
    valign = "center",
})

local update_uptime = function()
    awful.spawn.easy_async_with_shell("uptime | awk '{print $3}' | sed 's/,//;s/:/H /;s/$/M/'", function(stdout)
        local time = string.format(
            '<span foreground="%s" font="%s Bold 9"> %s </span>',
            pallete.brightblue,
            beautiful.font_alt,
            stdout:gsub("%\n", "")
        )
        uptime:set_markup(time)
    end)
end

gears.timer({
    timeout = 60,
    autostart = true,
    call_now = true,
    callback = function() update_uptime() end,
})

local tasks = {
    lock = "i3lock",
    sleep = "systemctl suspend",
    quit = 'echo "awesome.quit()" | awesome-client',
    restart = "systemctl reboot",
    poweroff = "systemctl poweroff",
}

local icons = {
    lock = "  ",
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
        bg_color = beautiful.module_bg,
        margins = dpi(2),
        horizontal_padding = dpi(0),
    })

    helpers.hover({
        widget = power_widgets[key]:get_children_by_id("box_container")[1],
        newbg = beautiful.module_bg_focused,
        oldbg = beautiful.module_bg,
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
                forced_width = dpi(120),
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(8),
            },
            layout = wibox.layout.align.vertical,
            expand = "none",
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(2),
    },
    helpers.padding_v(dpi(20)),
    {
        nil,
        nil,
        {
            power_widgets.lock,
            power_widgets.sleep,
            power_widgets.quit,
            power_widgets.restart,
            power_widgets.poweroff,
            spacing = dpi(12),
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
