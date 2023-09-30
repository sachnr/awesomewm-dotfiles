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

M.incVol = function(percentage) awful.spawn(string.format("wpctl set-volume @DEFAULT_AUDIO_SINK@ %s%%+", percentage)) end

M.decVol = function(percentage) awful.spawn(string.format("wpctl set-volume @DEFAULT_AUDIO_SINK@ %s%%-", percentage)) end

return M
