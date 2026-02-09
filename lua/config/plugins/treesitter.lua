local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "VeryLazy",
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
}

function M.config()
	-- Register custom BQN parser before installing.
	local parsers = require("nvim-treesitter.parsers")
	parsers.bqn = {
		install_info = {
			url = "https://github.com/shnarazk/tree-sitter-bqn",
			files = { "src/parser.c" },
			branch = "main",
			generate = false,
		},
		filetype = "bqn",
	}

	require("treesitter-context").setup({
		enable = true,
		max_lines = 0,
		trim_scope = "outer",
		patterns = {
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
		exact_patterns = {},
		zindex = 20,
		mode = "cursor",
	})

	require("nvim-treesitter-textobjects").setup({
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["as"] = {
					query = "@local.scope",
					query_group = "locals",
					desc = "Select language scope",
				},
			},
			selection_modes = {
				["@parameter.outer"] = "v",
				["@function.outer"] = "V",
				["@class.outer"] = "<c-v>",
			},
		},
		move = {
			enable = true,
			goto_next_start = {
				["]f"] = "@function.outer",
				["]c"] = "@class.outer",
				["]a"] = "@parameter.inner",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
				["]C"] = "@class.outer",
				["]A"] = "@parameter.inner",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
				["[a"] = "@parameter.inner",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
				["[C"] = "@class.outer",
				["[A"] = "@parameter.inner",
			},
		},
	})

	-- Enable treesitter highlighting and indentation.
	local filetypes =
		{ "lua", "vim", "c", "cpp", "rust", "nix", "python", "javascript", "typescript" }
	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetypes,
		callback = function()
			vim.treesitter.start()
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})

	-- Additional regex highlighting for specific languages.
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "rho", "k" },
		callback = function()
			vim.opt_local.syntax = "on"
		end,
	})

	vim.g.markdown_fenced_languages = { "sh", "bash", "rust", "cpp", "c" }
end

return M
