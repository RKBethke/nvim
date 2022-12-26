local M = {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
}

function M.config()
	local indent_blankline = require("indent_blankline")
	indent_blankline.setup({
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
		char = "▎",
	})
end

return M
