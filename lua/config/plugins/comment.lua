local M = {
	"numToStr/Comment.nvim",
	keys = { "gc", "gb" },
}

function M.init()
	require("config.mappings").comment()
end

function M.config()
	local comment = require("Comment")
	comment.setup()
end

return M
