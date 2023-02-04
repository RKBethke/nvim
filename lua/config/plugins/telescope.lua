local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",
	init = function()
		require("config.mappings").telescope()
	end,
}

function M.config()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},
			selection_caret = "  ",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.87,
				height = 0.50,
				preview_cutoff = 120,
			},
			mappings = {
				i = {
					["<ESC>"] = require("telescope.actions").close,
					["<C-j>"] = require("telescope.actions").move_selection_next,
					["<C-k>"] = require("telescope.actions").move_selection_previous,
					["<C-q>"] = require("telescope.actions").send_to_qflist,
				},
				n = {
					["<ESC>"] = require("telescope.actions").close,
					["q"] = require("telescope.actions").close,
				},
			},
			file_ignore_patterns = { "node_modules" },
			path_display = { "truncate" },
		},
		pickers = {
			find_files = {
				theme = "ivy",
			},
			buffers = {
				theme = "ivy",
			},
		},
	})
end

return M
