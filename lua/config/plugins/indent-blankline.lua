return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = "BufReadPre",
	opts = {
		exclude = {
			filetypes = {
				"help",
				"terminal",
				"dashboard",
				"packer",
				"lspinfo",
				"TelescopePrompt",
				"TelescopeResults",
				"lsp-installer",
				"NvimTree",
				"",
			},
			buftypes = {
				"terminal",
				"nofile",
			},
		},
		indent = {
			char = "┆",
		},
	},
}
