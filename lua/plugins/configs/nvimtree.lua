local present, nvimtree = pcall(require, "nvim-tree")
if not present then
	return
end

nvimtree.setup({
	filters = {
		dotfiles = false,
	},
	disable_netrw = true,
	hijack_netrw = true,
	ignore_ft_on_setup = { "dashboard" },
	open_on_tab = false,
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = false,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = false,
	},
	view = {
		side = "left",
		width = 25,
		hide_root_folder = false,
	},
	git = {
		enable = true,
		ignore = false,
	},
	actions = {
		open_file = {
			resize_window = true,
		},
	},
	renderer = {
		indent_markers = {
			enable = true,
		},
		add_trailing = false,
		highlight_git = true,
		highlight_opened_files = "none",
		icons = {
			show = {
				folder = true,
				file = true,
				git = true, -- git status
				folder_arrow = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				git = {
					deleted = "",
					ignored = "◌",
					renamed = "➜ ",
					staged = "✓",
					unmerged = "",
					unstaged = "✗",
					untracked = "★ ",
				},
				folder = {
					default = "",
					empty = "",
					empty_open = "",
					open = "",
					symlink = "",
					symlink_open = "",
					arrow_open = "",
					arrow_closed = "",
				},
			},
		},
	},
})
