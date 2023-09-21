return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>gs", "<cmd>G<cr>", desc = "status" },
		-- TODO: Map only for diff mode (vim.wo.diff)
		{ "<leader>dgh", "<cmd>diffget //2<CR>", desc = "diffget left" },
		{ "<leader>dgl", "<cmd>diffget //3<CR>", desc = "diffget left" },
	},
}
