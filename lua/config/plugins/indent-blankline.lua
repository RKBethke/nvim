return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
	opts = {
		filetype_exclude = {
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
		buftype_exclude = { "terminal", "nofile" },
		show_trailing_blankline_indent = false,
		show_first_indent_level = true,
		show_end_of_line = true,
		char = "▎",
		space_char_blankline = " ",
	},
}
