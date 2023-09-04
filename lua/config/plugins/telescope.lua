local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-project.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"direnv/direnv.vim",
	},
	cmd = "Telescope",
	init = function()
		require("config.mappings").telescope()
	end,
}

function M.config()
	local telescope = require("telescope")
	local actions = require("telescope.actions")
	local project_actions = require("telescope._extensions.project.actions")
	local base_dirs = {
		"~/src/",
		"~/.config/",
	}
	telescope.load_extension("file_browser")
	telescope.load_extension("project")
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
			-- Theme: Ivy
			layout_strategy = "bottom_pane",
			layout_config = {
				height = 25,
			},
			border = true,
			borderchars = {
				prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
				results = { " " },
				preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			},
			-- End Ivy Theme
			mappings = {
				i = {
					["<ESC>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-q>"] = actions.send_to_qflist,
				},
				n = {
					["<ESC>"] = actions.close,
					["q"] = actions.close,
				},
			},
			file_ignore_patterns = { "node_modules" },
			path_display = { "truncate" },
		},
		pickers = {
			buffers = {
				show_all_buffers = true,
				sort_lastused = true,
				mappings = {
					i = {
						["<c-d>"] = actions.delete_buffer,
					},
					n = {
						["d"] = actions.delete_buffer,
					}
				}
			}
		},
		extensions = {
			project = {
				base_dirs = base_dirs,
				hidden_files = true,
				theme = "ivy",
				order_by = "asc",
				search_by = "title",
				sync_with_nvim_tree = true,
				on_project_selected = function(prompt_bufnr)
					local cwd = vim.fn.getcwd()
					local new_path = project_actions.get_selected_path(prompt_bufnr)
					if new_path ~= cwd then
						project_actions.change_working_directory(prompt_bufnr, false)
					end
				end,
			},
			file_browser = {
				theme = "ivy",
				hijack_netrw = true,
			},
		},
	})

	vim.api.nvim_create_user_command("Reindex", function()
		require("telescope._extensions.project.git").update_git_repos(base_dirs)
	end, {})
end

return M
