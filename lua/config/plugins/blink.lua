return {
	"saghen/blink.cmp",
	lazy = false, -- lazy loading handled internally
	dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
	version = "*",
	opts = {
		keymap = { preset = "default" },
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		-- Experimental signature help support.
		signature = { enabled = true },
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
}
