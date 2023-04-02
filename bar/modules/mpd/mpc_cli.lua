local awful = require("awful.init")

local M = {}

M.toggle = function() awful.spawn("mpc toggle") end

M.prev = function() awful.spawn("mpc prev") end

M.next = function() awful.spawn("mpc next") end

return M
