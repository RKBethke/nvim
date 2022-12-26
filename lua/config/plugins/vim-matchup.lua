local M = {
	"andymass/vim-matchup",
	event = "BufReadPost",
}

function M.config()
	vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
end

return M
