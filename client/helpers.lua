-- Functions that you use more than once and in different files would
-- be nice to define here.

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local icons = require("icons.flaticons")
local naughty = require("naughty")

local helpers = {}

-- clickable container
helpers.ccontainer = function(widget)
    local container =
        wibox.widget {
        widget,
        widget = wibox.container.background
    }
    local old_cursor, old_wibox
    container:connect_signal(
        "mouse::enter",
        function()
            container.bg = beautiful.mouse_enter
            -- Hm, no idea how to get the wibox from this signal's arguments...
            local w = _G.mouse.current_wibox
            if w then
                old_cursor, old_wibox = w.cursor, w
                w.cursor = "hand1"
            end
        end
    )
    container:connect_signal(
        "mouse::leave",
        function()
            container.bg = beautiful.mouse_leave
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end
    )
    container:connect_signal(
        "button::press",
        function()
            container.bg = beautiful.mouse_press
        end
    )
    container:connect_signal(
        "button::release",
        function()
            container.bg = beautiful.mouse_release
        end
    )
    return container
end

-- watch
helpers.watch = function(script, time)
    return awful.widget.watch(
        script,
        time or 15,
        function(widget, stdout)
            widget.markup = stdout
            widget.font = beautiful.monospace
            collectgarbage("collect")
        end       
    )
end

-- create buttons for mouse left click
helpers.bmaker = function(widget, location)
    widget:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                nil,
                function()
                    awful.spawn(location)
                    awesome.emit_signal("dashboard::toggle", awful.screen.focused())
                end
            )
        )
    )
end

-- create icons
helpers.imaker = function(icon, dpix, dpiy)
    return wibox.widget {
        image = icon,
        resize = true,
        forced_width = dpix or dpi(20),
        forced_height = dpiy or dpi(20),
        widget = wibox.widget.imagebox
    }
end

helpers.run_once_pgrep = function(cmd)
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    awful.spawn.easy_async_with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

helpers.run_once_ps = function(findme, cmd)
    awful.spawn.easy_async_with_shell(
        string.format("ps -C %s|wc -l", findme),
        function(stdout)
            if tonumber(stdout) ~= 2 then
                awful.spawn(cmd, false)
            end
        end
    )
end

helpers.run_once_grep = function(command)
    awful.spawn.easy_async_with_shell(
        string.format("ps aux | grep '%s' | grep -v 'grep'", command),
        function(stdout)
            if stdout == "" or stdout == nil then
                awful.spawn(command, false)
            end
        end
    )
end

helpers.check_if_running = function(command, running_callback, not_running_callback)
    awful.spawn.easy_async_with_shell(
        string.format("ps aux | grep '%s' | grep -v 'grep'", command),
        function(stdout)
            if stdout == "" or stdout == nil then
                if not_running_callback ~= nil then
                    not_running_callback()
                end
            else
                if running_callback ~= nil then
                    running_callback()
                end
            end
        end
    )
end

-- rectangle
helpers.rect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

-- Create rounded rectangle shape (in one line)
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

helpers.prrect = function(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
    end
end

helpers.squircle = function(rate, delta)
    return function(cr, width, height)
        gears.shape.squircle(cr, width, height, rate, delta)
    end
end
helpers.psquircle = function(rate, delta, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partial_squircle(cr, width, height, tl, tr, br, bl, rate, delta)
    end
end

helpers.colorize_text = function(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function helpers.vertical_pad(height)
    return wibox.widget {
        forced_height = height,
        layout = wibox.layout.fixed.vertical
    }
end

function helpers.horizontal_pad(width)
    return wibox.widget {
        forced_width = width,
        layout = wibox.layout.fixed.horizontal
    }
end

function helpers.move_to_edge(c, direction)
    local old = c:geometry()
    local new =
        awful.placement[direction_translate[direction]](
        c,
        {honor_padding = true, honor_workarea = true, margins = beautiful.useless_gap * 2, pretend = true}
    )
    if direction == "up" or direction == "down" then
        c:geometry({x = old.x, y = new.y})
    else
        c:geometry({x = new.x, y = old.y})
    end
end

-- Add a hover cursor to a widget by changing the cursor on
-- mouse::enter and mouse::leave
-- You can find the names of the available cursors by opening any
-- cursor theme and looking in the "cursors folder"
-- For example: "hand1" is the cursor that appears when hovering over
-- links
function helpers.add_hover_cursor(w, hover_cursor)
    local original_cursor = "left_ptr"

    w:connect_signal(
        "mouse::enter",
        function()
            local w = _G.mouse.current_wibox
            if w then
                w.cursor = hover_cursor
            end
        end
    )

    w:connect_signal(
        "mouse::leave",
        function()
            local w = _G.mouse.current_wibox
            if w then
                w.cursor = original_cursor
            end
        end
    )
end

-- Tag back and forth:
-- If you try to focus the tag you are already at, go back to the previous tag.
-- Useful for quick switching after for example checking an incoming chat
-- message at tag 2 and coming back to your work at tag 1 with the same
-- keypress.
function helpers.tag_back_and_forth(tag_index)
    local s = mouse.screen
    local tag = s.tags[tag_index]
    if tag then
        if tag == s.selected_tag then
            awful.tag.history.restore()
        else
            tag:view_only()
        end
    end
end

-- Rounds a number to any number of decimals
function helpers.round(number, decimals)
    local power = 10 ^ decimals
    return math.floor(number * power) / power
end

function helpers.send_key(c, key)
    awful.spawn.with_shell("xdotool key --window " .. tostring(c.window) .. " " .. key)
end

function helpers.send_key_sequence(c, seq)
    awful.spawn.with_shell("xdotool type --delay 5 --window " .. tostring(c.window) .. " " .. seq)
end

function helpers.fake_escape()
    root.fake_input("key_press", "Escape")
    root.fake_input("key_release", "Escape")
end

function helpers.prompt(action, textbox, prompt, callback)
    if action == "run" then
        awful.prompt.run(
            {
                prompt = prompt,
                -- prompt       = "<b>Run: </b>",
                textbox = textbox,
                font = beautiful.monospace,
                done_callback = callback,
                exe_callback = awful.spawn,
                completion_callback = awful.completion.shell,
                history_path = awful.util.get_cache_dir() .. "/history"
            }
        )
    elseif action == "web_search" then
        awful.prompt.run(
            {
                prompt = prompt,
                -- prompt       = '<b>Web search: </b>',
                textbox = textbox,
                font = beautiful.monospace,
                history_path = awful.util.get_cache_dir() .. "/history_web",
                done_callback = callback,
                exe_callback = function(input)
                    if not input or #input == 0 then
                        return
                    end
                    awful.spawn.with_shell(
                        "xdg-open https://duckduckgo.com/?q="  .. input 
                    )
                    naughty.notify(
                        {
                            title = "Searching the web for",
                            text = input,
                            icon = gears.color.recolor_image(icons.browser, beautiful.accent_normal),
                            urgency = "low"
                        }
                    )
                end
            }
        )
    end
end

-- Create Boxed Widgets
local box_radius = beautiful.widget_box_radius
local box_gap = beautiful.widget_box_gap

helpers.create_boxed_widget = function(widget_to_be_boxed, width, height, bg_color, margin)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rect(box_radius)
    local boxed_widget =
        wibox.widget {
        -- Add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed horizontally
                nil,
                {
                    -- Center widget_to_be_boxed vertically
                    nil,
                    -- The actual widget goes here
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },
            widget = box_container
        },
        margins = margin or box_gap,
        color = beautiful.widget_margin_color,
        widget = wibox.container.margin
    }

    return boxed_widget
end

-- Useful for periodically checking the output of a command that
-- requires internet access.
-- Ensures that `command` will be run EXACTLY once during the desired
-- `interval`, even if awesome restarts multiple times during this time.
-- Saves output in `output_file` and checks its last modification
-- time to determine whether to run the command again or not.
-- Passes the output of `command` to `callback` function.
function helpers.remote_watch(command, interval, output_file, callback)
    local run_the_thing = function()
        -- Pass output to callback AND write it to file
        awful.spawn.easy_async_with_shell(
            command .. " | tee " .. output_file,
            function(out)
                callback(out)
            end
        )
    end

    local timer
    timer =
        gears.timer {
        timeout = interval,
        call_now = true,
        autostart = true,
        single_shot = false,
        callback = function()
            awful.spawn.easy_async_with_shell(
                "date -r " .. output_file .. " +%s",
                function(last_update, _, __, exitcode)
                    -- Probably the file does not exist yet (first time
                    -- running after reboot)
                    if exitcode == 1 then
                        run_the_thing()
                        return
                    end

                    local diff = os.time() - tonumber(last_update)
                    if diff >= interval then
                        run_the_thing()
                    else
                        -- Pass the date saved in the file since it is fresh enough
                        awful.spawn.easy_async_with_shell(
                            "cat " .. output_file,
                            function(out)
                                callback(out)
                            end
                        )

                        -- Schedule an update for when the remaining time to complete the interval passes
                        timer:stop()
                        gears.timer.start_new(
                            interval - diff,
                            function()
                                run_the_thing()
                                timer:again()
                            end
                        )
                    end
                end
            )
        end
    }
end

return helpers
