local M = {}
local awful = require("awful")

--- Set audio volume
---@param audio string sink/source
---@param vol integer
M.setVolume = function(audio, vol)
    local volume = vol / 100
    awful.spawn([[wpctl set-volume @DEFAULT_AUDIO_]] .. string.upper(audio) .. [[@ ]] .. volume)
end

--- Sink or Source Mute
---@param audio string source/sink
M.setMute = function(audio) awful.spawn("wpctl set-mute @DEFAULT_AUDIO_" .. string.upper(audio) .. "@ toggle") end

--- toggle sink output profile
---@param headphone boolean
M.toggleSink = function(headphone)
    if headphone then
        awful.spawn("pactl set-sink-port 0 analog-output-lineout")
    else
        awful.spawn("pactl set-sink-port 0 analog-output-headphones")
    end
end

return M
