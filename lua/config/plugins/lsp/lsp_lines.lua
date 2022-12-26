local M = {
	url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	dependencies = "neovim/nvim-lspconfig",
	keys = {
		{ "<leader>l", ":lua require('lsp_lines').toggle()<cr>" },
	},
	config = function()
		require("lsp_lines").setup()
	end,
}

return M
