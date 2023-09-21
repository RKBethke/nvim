return {
	url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	dependencies = "neovim/nvim-lspconfig",
	keys = {
		{
			"<leader>l",
			function()
				if vim.g.lsp_lines_enabled then
					require("lsp_lines").toggle()
				else
					vim.diagnostic.config({ virtual_lines = true })
					vim.g.lsp_lines_enabled = true
				end
			end,
			desc = "Toggle lsp lines"
		},
	},
	config = true,
}
