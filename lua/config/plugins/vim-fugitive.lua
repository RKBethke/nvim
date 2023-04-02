return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>gs", "<cmd>G<cr>" },
	},
	config = function()
		require("config.mappings").fugitive()
	end,
}
