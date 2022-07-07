--      ████████╗ █████╗  ██████╗     ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝     ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║██║  ███╗    ██║     ██║███████╗   ██║
--         ██║   ██╔══██║██║   ██║    ██║     ██║╚════██║   ██║
--         ██║   ██║  ██║╚██████╔╝    ███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚═╝╚══════╝   ╚═╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

-- ===================================================================
-- Widget Creation Functions
-- ===================================================================

-- default modkey
local modkey = "Mod4"

local taglist_buttons =
  gears.table.join(
  awful.button(
    {},
    1,
    function(t)
      t:view_only()
    end
  ),
  awful.button(
    {modkey},
    1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button(
    {modkey},
    3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end
  ),
  awful.button(
    {},
    4,
    function(t)
      awful.tag.viewnext(t.screen)
    end
  ),
  awful.button(
    {},
    5,
    function(t)
      awful.tag.viewprev(t.screen)
    end
  )
)

local TagList = function(s)
  local tag_list =
    awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    layout = {
      spacing = dpi(10),
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          {
            id = "text_role",
            widget = wibox.widget.textbox,
            font = beautiful.normal_fonts,
            align = "center",
            markup = "DD",
            valign = "center"
          },
          margins = dpi(8),
          widget = wibox.container.margin
        },
        widget = wibox.container.background
      },
      id = "background_role",
      bg = beautiful.accent_normal,
      widget = wibox.container.background,
      create_callback = function(self, c3, _)
        -- Tag Preview
        self:connect_signal(
          "mouse::enter",
          function()
            if #c3:clients() > 0 then
              awesome.emit_signal("bling::tag_preview::update", c3)
              awesome.emit_signal("bling::tag_preview::visibility", s, true)
            end
          end
        )

        self:connect_signal(
          "mouse::leave",
          function()
            awesome.emit_signal("bling::tag_preview::visibility", s, false)
          end
        )
      end,
      update_callback = function(self, c3, _)
        if c3.selected then
          self:get_children_by_id("background_role")[1].bg = beautiful.bg_normal
        elseif #c3:clients() == 0 then
          self:get_children_by_id("background_role")[1].bg = beautiful.fg_normal
        else
          self:get_children_by_id("background_role")[1].bg = beautiful.fg_critical
        end
      end
    },
    buttons = taglist_buttons
  }
  return tag_list
end

return TagList
