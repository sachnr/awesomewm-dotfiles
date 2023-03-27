local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears.init")

local cmds = {
    kill = "ps x | grep 'mpc idleloop player' | grep -v grep | awk '{print $1}' | xargs kill",
    start = 'bash -c "mpc idleloop player"',
    status = "mpc -f 'artist:{%artist%}\ntitle:{%title%}\nfile:{%file%}\nalbum:{%album%}\ntime:{%time%}'",
    music_dir = os.getenv("HOME") .. "/Music/",
    cover_path = "/tmp/.music_cover.png",
}

local function dump_cover(file_path)
    awful.spawn.easy_async_with_shell(
        string.format('ffmpeg -i "%s" "%s" -y', file_path, cmds.cover_path),
        function(_, _, _, exitcode)
            if exitcode == 0 then
                ---@diagnostic disable-next-line: param-type-mismatch
                local image = gears.surface.load_uncached(cmds.cover_path)
                awesome.emit_signal("mpd::cover_art", image)
            else
                awesome.emit_signal("mpd::cover_art", beautiful.cover_art)
            end
        end
    )
end

--- emit signal on new event
local function emit_status()
    awful.spawn.easy_async_with_shell(cmds.status, function(stdout)
        local dir = stdout:match("file:{(.-)}")
        local file_path = cmds.music_dir .. dir
        dump_cover(file_path)
        local t = {
            artist = stdout:match("artist:{(.-)}"),
            title = stdout:match("title:{(.-)}"),
            album = stdout:match("album:{(.-)}"),
            time = stdout:match("time:{(.-)}"),
            status = stdout:match("%[(%a+)%]"),
            volume = stdout:match("volume:(%d+)"),
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
