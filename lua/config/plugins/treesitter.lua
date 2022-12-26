local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
	},
}

function M.config()
	local ts_context = require("treesitter-context")
	ts_context.setup({
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
		trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
			default = {
				"class",
				"function",
				"method",
				"for",
				"while",
				"if",
				"switch",
				"case",
			},

			rust = {
				"loop_expresssion",
				"impl_item",
			},
		},
		exact_patterns = {
			-- Example for a specific filetype with Lua patterns
			-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
			-- exactly match "impl_item" only)
			-- rust = true,
		},
		zindex = 20, -- The Z-index of the context window
		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	})

	local ts_config = require("nvim-treesitter.configs")
	ts_config.setup({
		ensure_installed = {
			"lua",
			"vim",
			"comment",
			"nix",
		},
		highlight = {
			enable = true,
			use_languagetree = true,
		},
		indent = {
			enable = true,
		},
		matchup = {
			enable = true,
		},
	})
end

return M
