-- =========================================================
-- ======================= IMPORTS =========================
-- =========================================================

local awful = require("awful")
local top_panel = require("panels.top-panel")
local dashboard = require("panels.dashboard")

-- =========================================================
-- =================== INITIALIZATION ======================
-- =========================================================

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    -- Create the Top bar
    s.top_panel = top_panel.create(s)
    s.dashboard = dashboard.create(s)
  end
)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      -- Order matter here for shadow
      s.top_panel.visible = not fullscreen
      if s.dashboard then
        if fullscreen and s.dashboard.visible then
          s.dashboard.visible = false
        end
      end
    end
  end
end


_G.tag.connect_signal(
  "property::selected",
  function(t)
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  "property::fullscreen",
  function(c)
    c.screen.selected_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  "unmanage",
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end
)
