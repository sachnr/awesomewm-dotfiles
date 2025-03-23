local awful = require("awful.init")

-- reload processes on config reload
awful.spawn.easy_async_with_shell(
	'ps x | grep "blueman-applet" | grep -v grep | awk "{print $1}" | xargs kill',
	function()
		awful.spawn("blueman-applet")
	end
)

awful.spawn.easy_async_with_shell('ps x | grep "nm-applet" | grep -v grep | awk "{print $1}" | xargs kill', function()
	awful.spawn("nm-applet --indicator")
end)
--
awful.spawn.easy_async_with_shell('ps x | grep "pasystray" | grep -v grep | awk "{print $1}" | xargs kill', function()
	awful.spawn("pasystray")
end)

-- awful.spawn("xrandr --output HDMI-0 --primary --mode 1280x960 --rate 144")
-- awful.spawn("xrandr --output HDMI-0 --primary --mode 1920x1080 --rate 144")
-- awful.spawn("xrandr --output DP-0 --primary --mode 1920x1080 --rate 144")
--
awful.spawn("nvidia-settings --load-config-only")
awful.spawn("autorandr --load desktop")

awful.spawn.easy_async_with_shell(
	'ps x | grep "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" | grep -v grep | awk "{print $1}" | xargs kill',
	function()
		awful.spawn("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	end
)

awful.spawn.easy_async_with_shell('ps x | grep "picom" | grep -v grep | awk "{print $1}" | xargs kill', function()
	awful.spawn("picom")
end)

awful.spawn("xset r rate 560 50")
