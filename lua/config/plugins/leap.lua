return {
	"ggandor/leap.nvim",
	event = "BufReadPost",
	config = function()
		require("leap").add_default_mappings()
		-- Reset default behavior of 'x' and 'X'
		vim.keymap.del({ "v", "o" }, "x")
		vim.keymap.del({ "v", "o" }, "X")
	end,
}
