return {
	url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	dependencies = "neovim/nvim-lspconfig",
	keys = {
		{ "<leader>l", ":lua require('lsp_lines').toggle()<cr>" },
	},
	config = true,
}
