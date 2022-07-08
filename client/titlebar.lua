local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("client.helpers")

-- =========================================================
-- ============= Function for making buttons ===============
-- =========================================================

local decorations = function(c, shape, color, unfocused_color, hover_color, size, margin, cmd, icon)
	local button =
		wibox.widget(
		{
			wibox.widget {
				image = icon,
				resize = true,
				widget = wibox.widget.imagebox
			},
			bg = (client.focus and c == client.focus) and color or unfocused_color,
			shape = shape,
			widget = wibox.container.background()
		}
	)

	--- Instead of adding spacing between the buttons, we add margins
	--- around them. That way it is more forgiving to click them
	--- (especially if they are very small)
	local button_widget =
		wibox.widget(
		{
			{
				margins = margin,
				{
					button,
					height = size,
					width = size,
					strategy = "exact",
					widget = wibox.container.constraint
				},
				widget = wibox.container.margin
			},
			widget = wibox.container.place
		}
	)

	local button_commands = {
		["close"] = {
			fun = function(c)
				c:kill()
			end,
			track_property = nil
		},
		["maximize"] = {
			fun = function(c)
				c.maximized = not c.maximized
				c:raise()
			end,
			track_property = "maximized"
		},
		["minimize"] = {
			fun = function(c)
				c.minimized = true
			end
		},
		["sticky"] = {
			fun = function(c)
				c.sticky = not c.sticky
				c:raise()
			end,
			track_property = "sticky"
		},
		["ontop"] = {
			fun = function(c)
				c.ontop = not c.ontop
				c:raise()
			end,
			track_property = "ontop"
		},
		["floating"] = {
			fun = function(c)
				c.floating = not c.floating
				c:raise()
			end,
			track_property = "floating"
		}
	}

	button_widget:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				function()
					button_commands[cmd].fun(c)
				end
			)
		)
	)

	local p = button_commands[cmd].track_property
	--- Track client property if needed
	if p then
		c:connect_signal(
			"property::" .. p,
			function()
				button.bg = c[p] and color .. "40" or color
			end
		)
		c:connect_signal(
			"focus",
			function()
				button.bg = c[p] and color .. "40" or color
			end
		)
		button_widget:connect_signal(
			"mouse::leave",
			function()
				if c == client.focus then
					button.bg = c[p] and color .. "40" or color
				else
					button.bg = unfocused_color
				end
			end
		)
	else
		button_widget:connect_signal(
			"mouse::leave",
			function()
				if c == client.focus then
					button.bg = color
				else
					button.bg = unfocused_color
				end
			end
		)
		c:connect_signal(
			"focus",
			function()
				button.bg = color
			end
		)
	end
	button_widget:connect_signal(
		"mouse::enter",
		function()
			button.bg = hover_color
		end
	)
	c:connect_signal(
		"unfocus",
		function()
			button.bg = unfocused_color
		end
	)

	return button_widget
end

-- =========================================================
-- ==================== Functionality ======================
-- =========================================================

local button_size = beautiful.titlebar_buttonsize
local button_size_alt = beautiful.titlebar_buttonsize_alt
local button_margin = {top = dpi(2), bottom = dpi(2), left = dpi(5), right = dpi(5)}
local button_shape = gears.shape.circle

local function close(c)
	return decorations(
		c,
		button_shape,
		beautiful.accent_normal_c,
		beautiful.accent_mouse_enter,
		beautiful.accent_mouse_press,
		button_size,
		button_margin,
		"close",
		beautiful.close_icon
	)
end

local function minimize(c)
	return decorations(
		c,
		button_shape,
		beautiful.accent_normal_alt,
		beautiful.accent_mouse_enter_alt,
		beautiful.accent_mouse_press_alt,
		button_size_alt,
		button_margin,
		"minimize",
		beautiful.minimize_icon
	)
end

local function maximize(c)
	return decorations(
		c,
		button_shape,
		beautiful.accent_normal_alt_alt,
		beautiful.accent_mouse_enter_alt_alt,
		beautiful.accent_mouse_press_alt_alt,
		button_size_alt,
		button_margin,
		"maximize",
		beautiful.maximize_icon
	)
end

--- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
	"request::titlebars",
	function(c)
		awful.titlebar(
			c,
			{position = "top", size = beautiful.titlebar_size, font = beautiful.title_fonts, bg = beautiful.transparent}
		):setup(
			{
				{
					layout = wibox.layout.align.horizontal,
					--- Left
					nil,
					{
						--- Middle
						{
							--- Title
							align = "center",
							font = beautiful.title_font,
							widget = awful.titlebar.widget.titlewidget(c),
							buttons = {
								--- Move client
								awful.button(
									{
										modifiers = {},
										button = 1,
										on_press = function()
											c.maximized = false
											c:activate({context = "mouse_click", action = "mouse_move"})
										end
									}
								),
								--- Kill client
								awful.button(
									{
										modifiers = {},
										button = 2,
										on_press = function()
											c:kill()
										end
									}
								),
								--- Resize client
								awful.button(
									{
										modifiers = {},
										button = 3,
										on_press = function()
											c.maximized = false
											c:activate({context = "mouse_click", action = "mouse_resize"})
										end
									}
								),
								--- Side button up
								awful.button(
									{
										modifiers = {},
										button = 9,
										on_press = function()
											c.floating = not c.floating
										end
									}
								),
								--- Side button down
								awful.button(
									{
										modifiers = {},
										button = 8,
										on_press = function()
											c.ontop = not c.ontop
										end
									}
								)
							}
						},
						layout = wibox.layout.flex.horizontal
					},
					--- Right
					{
						minimize(c),
						maximize(c),
						close(c),
						--- Create some extra padding at the edge
						helpers.horizontal_pad(dpi(5)),
						layout = wibox.layout.fixed.horizontal
					},
					left = dpi(10),
					widget = wibox.container.margin
				},
				bg = beautiful.titlebar_color .. "c0",
				widget = wibox.container.background
			}
		)
	end
)
