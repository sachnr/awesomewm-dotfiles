-- =========================================================
-- =================== System Monitor ======================
-- =========================================================

local wibox = require("wibox")

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local icons = require("icons.flaticons")

local lain_cpu = require("widget.lain.cpu")
local lain_mem = require("widget.lain.mem")

local helpers = require("client.helpers")

-- ~~~~~~~~~~~~~~~~ setup ~~~~~~~~~~~~~~~~~~~

-- -------- Images -----------
local activity_icon = helpers.imaker(icons.activity)
local network_icon = helpers.imaker(icons.globe, dpi(15), dpi(15))
local cpu_icon = helpers.imaker(icons.cpu)
local gpu_icon = helpers.imaker(icons.gpu, dpi(20), dpi(30))
local disk_icon = helpers.imaker(icons.harddisk, dpi(20), dpi(30))

-- ----- Widget Setup --------
local gpu_mem_used = [[sh -c "nvidia-smi | awk 'NR==10{print $9}' | sed 's/MiB/M/g'"]]
--local gpu_mem_max = [[sh -c "nvidia-smi | awk 'NR==10{print}' | awk '{print $11}' | sed 's/MiB//g'"]]
local gpu_temp_script = [[sh -c "nvidia-smi | awk 'NR==10{print}' | cut -c 8-10"]]
local cpu_temp_script = [[sh -c "sensors | grep Package | awk '{print $4}' | cut -c 2-3"]]
local disk_max = [[sh -c "df -h | grep /dev/ | awk 'NR==1{print $2}'"]]
local disk_used = [[sh -c "df -h | grep /dev/ | awk 'NR==1{print $3}'"]]

-- --------- init ------------
local net_speed_widget = require("widget.net-speed-widget.net-speed")
local cpu_temp = helpers.watch(cpu_temp_script)
local gpu_temp = helpers.watch(gpu_temp_script)
local gpu_percent = helpers.watch(gpu_mem_used, 2)
local disk_max_no = helpers.watch(disk_max, 1200)
local disk_used_no = helpers.watch(disk_used, 1200)
local disk_text = wibox.widget.textbox("/")
local celcius = wibox.widget.textbox("°C")
celcius.font = beautiful.monospace
local mem =
    lain_mem(
    {
        settings = function()
            widget:set_markup('<span font="' .. beautiful.monospace .. '">' .. mem_now.used .. ' M</span>')
        end
    }
)
local mycpu =
    lain_cpu(
    {
        settings = function()
            widget:set_markup('<span font="' .. beautiful.monospace .. '">' .. cpu_now.usage .. ' %</span>')
        end
    }
)

-- system monitor
local user_widget =
    wibox.widget {
    {
        helpers.horizontal_pad(dpi(35)),
        network_icon,
        helpers.horizontal_pad(dpi(5)),
        net_speed_widget,
        widget = wibox.container.margin,
        forced_height = dpi(20),
        layout = wibox.layout.fixed.horizontal
    },
    {
        helpers.horizontal_pad(dpi(35)),
        {
            cpu_icon,
            helpers.horizontal_pad(dpi(5)),
            mycpu,
            helpers.horizontal_pad(dpi(5)),
            cpu_temp,
            celcius,
            forced_width = dpi(130),
            draw_empty = true,
            widget = wibox.container.margin,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            gpu_icon,
            helpers.horizontal_pad(dpi(5)),
            gpu_percent,
            helpers.horizontal_pad(dpi(5)),
            gpu_temp,
            celcius,
            forced_width = dpi(130),
            draw_empty = true,
            widget = wibox.container.margin,
            layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin,
        forced_height = dpi(20),
        layout = wibox.layout.fixed.horizontal
    },
    {
        helpers.horizontal_pad(dpi(35)),
        {
            activity_icon,
            helpers.horizontal_pad(dpi(5)),
            mem,
            forced_width = dpi(130),
            draw_empty = true,
            widget = wibox.container.margin,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            disk_icon,
            helpers.horizontal_pad(dpi(5)),
            disk_used_no,
            disk_text,
            disk_max_no,
            forced_width = dpi(130),
            draw_empty = true,
            widget = wibox.container.margin,
            layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin,
        forced_height = dpi(20),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}

helpers.bmaker(user_widget, apps.taskmanager)
helpers.add_hover_cursor(user_widget, "hand1")
return user_widget