local M = {}

M.statusline = function()
	return require("ui.statusline").run()
end

M.setup = function()
	vim.opt.statusline = "%!v:lua.require('ui').statusline()"
end

return M
