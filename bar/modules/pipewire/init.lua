local M = {}

M.setup = function(style)
	if style == "vertical" then
		return require("bar.modules.pipewire.vertical")
	else
		return require("bar.modules.pipewire.horizontal")
	end
end

return M
