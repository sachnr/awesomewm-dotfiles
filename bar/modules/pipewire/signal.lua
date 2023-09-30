local awful = require("awful")

local function get_icon(ismuted, volume)
    if ismuted then
        return " 󰝟  "
    else
        if volume < 50 then
            return " 󰕿 "
        elseif volume < 100 then
            return " 󰖀  "
        else
            return " 󰕾  "
        end
    end
end

local function emit_signal()
    awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
        local muted = false
        local volume = tonumber(stdout:match("(%d%.%d%d?)")) * 100
        if stdout:match("MUTED") then muted = true end
        local icon = get_icon(muted, volume)
        awesome.emit_signal("volume::update", volume, icon)
    end)
end

emit_signal()

awful.spawn.easy_async_with_shell(
    "ps x | grep \"pactl subscribe\" | grep -v grep | awk '{print $1}' | xargs kill",
    function()
        -- use shell
        awful.spawn.with_line_callback(
            [[bash -c "pactl subscribe | grep --line-buffered \"Event 'change' on sink #\""]],
            {
                stdout = function(_) emit_signal() end,
            }
        )
    end
)
