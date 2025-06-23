local function get_win_width()
	local wid = vim.api.nvim_get_current_win()
	local wininfo = vim.fn.getwininfo(wid)[1]
	local win_width = vim.bo.textwidth + wininfo.textoff + 2
	vim.notify("textwidth=" .. vim.bo.textwidth, vim.log.levels.INFO)
	vim.notify("textoff=" .. wininfo.textoff, vim.log.levels.INFO)
	vim.notify("win_width=" .. win_width, vim.log.levels.INFO)
	return win_width
end

return {
	"shortcuts/no-neck-pain.nvim",
	cmd = "NoNeckPain",
	keys = { { "<leader>z", "<cmd>NoNeckPain<cr>", desc = "Zen Mode" } },
	config = function()
		local nnp = require("no-neck-pain")
		nnp.setup({
			width = get_win_width(),
		})
	end,
}
