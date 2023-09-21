local util = require("util")

local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-project.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"direnv/direnv.vim",
	},
	keys = {
		{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
		{ "<leader>/", util.telescope("live_grep"), desc = "Grep (root dir)" },
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader><space>", util.telescope("files"), desc = "Find Files (root dir)" },
		-- find
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>ff", util.telescope("files"), desc = "Find Files (root dir)" },
		{ "<leader>fF", util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		{ "<leader>fR", util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
		-- git
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		-- search
		{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
		{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
		{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
		{ "<leader>sg", util.telescope("live_grep"), desc = "Grep (root dir)" },
		{ "<leader>sG", util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
		{ "<leader>sw", util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
		{ "<leader>sW", util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
		{ "<leader>sw", util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
		{ "<leader>sW", util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
		{ "<leader>uC", util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
		{
			"<leader>ss",
			util.telescope("lsp_document_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol",
		},
		{
			"<leader>sS",
			util.telescope("lsp_dynamic_workspace_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol (Workspace)",
		},
	},
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
					},
				},
			},
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
