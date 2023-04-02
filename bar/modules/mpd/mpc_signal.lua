local awful = require("awful")

local cmds = {
    kill = "ps x | grep 'mpc idleloop player' | grep -v grep | awk '{print $1}' | xargs kill",
    start = "mpc idleloop player",
    status = "mpc -f 'artist:{%artist%}\ntitle:{%title%}\nfile:{%file%}\nalbum:{%album%}'",
    music_dir = os.getenv("HOME") .. "Music/",
}

--- emit signal on new event
local function emit_status()
    awful.spawn.easy_async_with_shell(cmds.status, function(stdout)
        local t = {
            artist = stdout:match("artist:{(.-)}"),
            title = stdout:match("title:{(.-)}"),
            dir = stdout:match("file:{(.-)}"),
            album = stdout:match("album:{(.-)}"),
            status = stdout:match("%[(%a+)%]"),
            -- progress = stdout:match("#%d+/%d+   (%d+:%d+/%d+:%d+)"),
            volume = stdout:match("volume:(%d+)"),
            repeat_setting = stdout:match("repeat: (%a+)"),
            random = stdout:match("random: (%a+)"),
            single = stdout:match("single: (%a+)"),
            consume = stdout:match("consume: (%a+)"),
        }
        ---@diagnostic disable-next-line: undefined-global
        awesome.emit_signal("mpd::status", t)
    end)
end

-- load on startup
emit_status()

awful.spawn.easy_async_with_shell(cmds.kill, function()
    awful.spawn.with_line_callback(cmds.start, {
        stdout = function(_) emit_status() end,
    })
end)
