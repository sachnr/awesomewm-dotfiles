local gears = require("gears")
local helpers = require("client.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local icon_dir = gears.filesystem.get_configuration_dir() .. "icons/weather/"
local icons = function(icon_name)
    local location = icon_dir .. icon_name .. ".svg"
    return location
end
local weather_temperature_symbol
if WEATHER.units == "metric" then
    weather_temperature_symbol = " °C"
else
    weather_temperature_symbol = " °F"
end
local weather_text =
    wibox.widget {
    markup = '<span>"Weather unavailable"</span>',
    -- align  = 'center',
    valign = "center",
    font = "Roboto 10",
    widget = wibox.widget.textbox
}
local weather_icon = wibox.widget.imagebox(icons("na"))
weather_icon.resize = true
weather_icon.forced_width = 40
weather_icon.forced_height = 40

local weather =
    wibox.widget {
    weather_icon,
    weather_text,
    layout = wibox.layout.fixed.horizontal
}

local weather_icons = {
    ["01d"] = icons("sun"),
    ["01n"] = icons("moon"),
    ["02d"] = icons("dfcloud"),
    ["02n"] = icons("nfcloud"),
    ["03d"] = icons("dfcloud"),
    ["03n"] = icons("nfcloud"),
    ["04d"] = icons("dbcloud"),
    ["04n"] = icons("nbcloud"),
    ["09d"] = icons("dsrain"),
    ["09n"] = icons("nsrain"),
    ["10d"] = icons("drain"),
    ["10n"] = icons("nrain"),
    ["11d"] = icons("dtstorm"),
    ["11n"] = icons("ntstorm"),
    ["13d"] = icons("dsnow"),
    ["13n"] = icons("nsnow"),
    ["40d"] = icons("mist"),
    ["40n"] = icons("mist"),
    ["50d"] = icons("mist"),
    ["50n"] = icons("mist"),
    ["_"] = icons("na")
}

awesome.connect_signal(
    "evil::weather",
    function(temperature, description, icon_code)
        if weather_icons[icon_code] then
            weather_icon.image = weather_icons[icon_code]
        else
            weather_icon.image = weather_icons["_"]
        end

        weather_text.markup ='<span>' .. description .. ' ' .. tostring(temperature) .. weather_temperature_symbol .. '</span>'
    end
)

return weather
