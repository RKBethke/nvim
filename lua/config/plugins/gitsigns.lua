local M = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
}

function M.config()
	local gitsigns = require("gitsigns")
	gitsigns.setup({
		signs = {
			add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
			change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
			delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
			topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
			changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
		},
		on_attach = function(bufnr)
			require("config.mappings").gitsigns(bufnr)
		end,
	})
end

return M
