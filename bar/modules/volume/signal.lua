local awful = require("awful")
_G.headphones = false

local function get_icon(isHeadphone, ismuted, volume)
    if ismuted then
        if isHeadphone then return " 󰟎 " end
        return "  "
    end
    if isHeadphone then
        return " 󰋋 "
    else
        if volume < 50 then
            return "  "
        elseif volume < 100 then
            return "  "
        else
            return "  "
        end
    end
end

local function emit_signal()
    awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
        local muted = false
        local volume = tonumber(stdout:match("(%d%.%d%d?)")) * 100
        if stdout:match("MUTED") then muted = true end
        local icon = get_icon(headphones, muted, volume)
        awesome.emit_signal("volume::update", volume, icon)
    end)
end

awful.spawn.easy_async_with_shell("pactl list sinks |& grep -E 'Active Port: analog'", function(stdout)
    if stdout:match("lineout") then
        _G.headphones = false
    else
        _G.headphones = true
    end
    emit_signal()
end)

awful.spawn.easy_async_with_shell(
    "ps x | grep \"pactl subscribe\" | grep -v grep | awk '{print $1}' | xargs kill",
    function()
        -- use shell
        awful.spawn.with_line_callback([[bash -c "pactl subscribe | grep --line-buffered \"Event 'change' on sink #\""]], {
            stdout = function(_) emit_signal() end,
        })
    end
)
