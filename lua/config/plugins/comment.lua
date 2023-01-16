return {
	"numToStr/Comment.nvim",
	keys = { "gc", "gb" },
	init = function()
		require("config.mappings").comment()
	end,
}
