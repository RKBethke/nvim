local util = require("util")

local live_multigrep = function(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }
			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			---@diagnostic disable-next-line: deprecated
			return vim.tbl_flatten({
				args,
				{
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
			})
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})
	pickers
		.new(opts, {
			prompt_title = "Multi Grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		:find()
end

local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-project.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"direnv/direnv.vim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
		{
			"<leader>/",
			function()
				live_multigrep({ cwd = util.get_root() })
			end,
			desc = "Grep (root dir)",
		},
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader><space>", util.telescope("files"), desc = "Find Files (root dir)" },
		{ "<leader>?", "<cmd>Telescope resume<cr>", desc = "Resume" },

		-- Find
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>fF", util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		{
			"<leader>fR",
			util.telescope("oldfiles", { cwd = vim.uv.cwd() }),
			desc = "Recent (cwd)",
		},

		-- Git
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },

		-- Search
		{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
		{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
		{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		{
			"<leader>sw",
			util.telescope("grep_string", { word_match = "-w" }),
			desc = "Word (root dir)",
		},
		{
			"<leader>sW",
			util.telescope("grep_string", { cwd = false, word_match = "-w" }),
			desc = "Word (cwd)",
		},
		{ "<leader>sw", util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
		{
			"<leader>sW",
			util.telescope("grep_string", { cwd = false }),
			mode = "v",
			desc = "Selection (cwd)",
		},
		{
			"<leader>uC",
			util.telescope("colorscheme", { enable_preview = true }),
			desc = "Colorscheme with preview",
		},
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
	local base_dirs = { "~/src/", "~/.config/" }
	telescope.load_extension("file_browser")
	telescope.load_extension("project")
	telescope.load_extension("fzf")
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
			layout_config = { height = 25 },
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
					local new_path = project_actions.get_selected_path(prompt_bufnr)
					if new_path ~= vim.fn.getcwd() then
						project_actions.change_working_directory(prompt_bufnr, false)
					end
				end,
			},
			file_browser = {
				theme = "ivy",
				hijack_netrw = true,
			},
			fzf = {},
		},
	})

	vim.api.nvim_create_user_command("Reindex", function()
		require("telescope._extensions.project.git").update_git_repos(base_dirs)
	end, {})
end

return M
