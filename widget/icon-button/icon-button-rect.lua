local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local helpers = require("client.helpers")

function build(imagebox, res)
  -- return wibox.container.margin(container, 6, 6, 6, 6)
  return wibox.widget {
    wibox.widget {
      wibox.widget {
        imagebox,
        top = dpi(6),
        left = dpi(6),
        right = dpi(6),
        bottom = dpi(6),
        widget = wibox.container.margin
      },
      shape = helpers.rrect(res or dpi(12)),
      widget = helpers.ccontainer
    },
    top = dpi(6),
    left = dpi(6),
    right = dpi(6),
    bottom = dpi(6),
    widget = wibox.container.margin
  }
end

return build
