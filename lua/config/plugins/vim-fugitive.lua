return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>gs", "<cmd>G<cr>", desc = "status" },
		{ "<leader>gd", "<cmd>Gvdiffsplit!<cr>", desc = "vdiffsplit" },
		-- TODO: Map only for diff mode (vim.wo.diff)
		{ "dgh", "<cmd>diffget //2<CR>", desc = "diffget left" },
		{ "dgl", "<cmd>diffget //3<CR>", desc = "diffget right" },
	},
}
