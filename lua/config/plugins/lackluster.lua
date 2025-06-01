return {
	"slugbyte/lackluster.nvim",
	lazy = false,
	priority = 1100,
	config = function()
		local ll = require("lackluster")
		ll.setup({
			tweak_syntax = {
				comment = ll.color.green,
			},
			tweak_highlight = {
				["Visual"] = {
					link = "CursorLine",
				},
			},
		})
		vim.cmd.colorscheme("lackluster-hack")
	end,
}
