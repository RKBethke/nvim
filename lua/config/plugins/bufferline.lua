local M = {
	"akinsho/bufferline.nvim",
	event = "BufReadPre",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
}

function M.config()
	local bufferline = require("bufferline")
	-- local colors = require("config.plugins.gruvbox-material").colors

	bufferline.setup({
		options = {
			offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
			buffer_close_icon = "",
			modified_icon = "",
			close_icon = "",
			show_close_icon = true,
			left_trunc_marker = "",
			right_trunc_marker = "",
			max_name_length = 14,
			max_prefix_length = 13,
			tab_size = 16,
			show_tab_indicators = true,
			enforce_regular_tabs = false,
			view = "multiwindow",
			show_buffer_close_icons = true,
			separator_style = "thin",
			always_show_bufferline = true,
			diagnostics = false,
			themable = true,
		},
		-- highlights = {
		-- 	background = {
		-- 		fg = colors.fgfaded,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	buffer_selected = {
		-- 		fg = colors.fg,
		-- 		bg = colors.bg,
		-- 		bold = true,
		-- 	},
		-- 	buffer_visible = {
		-- 		fg = colors.fgfaded,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	error = {
		-- 		fg = colors.fgfaded,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	error_diagnostic = {
		-- 		fg = colors.fgfaded,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	close_button = {
		-- 		fg = colors.fgfaded,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	close_button_visible = {
		-- 		fg = colors.fgfaded,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	close_button_selected = {
		-- 		fg = colors.red,
		-- 		bg = colors.bg,
		-- 	},
		-- 	fill = {
		-- 		fg = colors.grey_fg,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	indicator_selected = {
		-- 		fg = colors.bg,
		-- 		bg = colors.bg,
		-- 	},
		-- 	modified = {
		-- 		fg = colors.red,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	modified_visible = {
		-- 		fg = colors.red,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	modified_selected = {
		-- 		fg = colors.green,
		-- 		bg = colors.bg,
		-- 	},
		-- 	separator = {
		-- 		fg = colors.lightbg,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	separator_visible = {
		-- 		fg = colors.lightbg,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	separator_selected = {
		-- 		fg = colors.lightbg,
		-- 		bg = colors.lightbg,
		-- 	},
		-- 	tab = {
		-- 		fg = colors.light_grey,
		-- 		bg = colors.bg,
		-- 	},
		-- 	tab_selected = {
		-- 		fg = colors.lightbg,
		-- 		bg = colors.blue,
		-- 	},
		-- 	tab_close = {
		-- 		fg = colors.red,
		-- 		bg = colors.bg,
		-- 	},
		-- },
	})

	require("config.mappings").bufferline()
end

return M
