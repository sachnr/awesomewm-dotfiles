local awful = require("awful.init")

-- reload processes on config reload
awful.spawn.easy_async_with_shell(
    'ps x | grep "blueman-applet" | grep -v grep | awk "{print $1}" | xargs kill',
    function() awful.spawn("blueman-applet") end
)

awful.spawn.easy_async_with_shell(
    'ps x | grep "nm-applet" | grep -v grep | awk "{print $1}" | xargs kill',
    function() awful.spawn("nm-applet --indicator") end
)

-- awful.spawn("xrandr --output HDMI-0 --primary --mode 1280x960 --rate 144")
awful.spawn("xrandr --output HDMI-0 --primary --mode 1920x1080 --rate 144")
