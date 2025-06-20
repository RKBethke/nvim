local function get_win_width()
	local wid = vim.api.nvim_get_current_win()
	local wininfo = vim.fn.getwininfo(wid)[1]
	return vim.bo.textwidth + wininfo.textoff
end

return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	cmd = "NoNeckPain",
	keys = { { "<leader>z", "<cmd>NoNeckPain<cr>", desc = "Zen Mode" } },
	config = function()
		local nnp = require("no-neck-pain")
		nnp.setup({
			width = get_win_width(),
		})
	end,
}
