local M = {
	"ggandor/leap.nvim",
	event = "BufReadPost",
}

function M.config()
	require("config.mappings").leap()
end

return M
