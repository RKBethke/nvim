return {
	"blazkowolf/gruber-darker.nvim",
	lazy = true,
	priority = 1000,
	config = function()
		local gruber = require("gruber-darker")
		gruber.setup({
			bold = false,
			underline = true,
			undercurl = false,
			italic = {
				strings = false,
				operators = false,
				comments = true,
				folds = true,
			},
		})
	end,
}
