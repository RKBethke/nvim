return {
	"ggandor/leap.nvim",
	event = "BufReadPost",
	config = function()
		require("config.mappings").leap()
	end,
}
