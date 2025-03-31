return {
	"saghen/blink.cmp",
	dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
	version = "*",
	opts = {
		keymap = { preset = "default" },
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		signature = { enabled = true }, -- Experimental signature help support.
		completion = {
			accept = {
				auto_brackets = { enabled = true },
			},
			menu = {
				draw = {
					-- Use treesitter to highlight the label text for the given list of sources.
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
		},
	},
	opts_extend = { "sources.default" },
}
