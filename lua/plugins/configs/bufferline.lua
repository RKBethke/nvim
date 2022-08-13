local colors = require("colors." .. vim.g.theme).colors

local present, bufferline = pcall(require, "bufferline")
if not present then
	return
end

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
		custom_filter = function(buf_number)
			-- Func to filter out our managed/persistent split terms
			local present_type, type = pcall(function()
				return vim.api.nvim_buf_get_var(buf_number, "term_type")
			end)

			if present_type then
				if type == "vert" then
					return false
				elseif type == "hori" then
					return false
				end
				return true
			end

			return true
		end,
	},

	highlights = {
		background = {
			fg = colors.fgfaded,
			bg = colors.lightbg,
		},

		-- buffers
		buffer_selected = {
			fg = colors.fg,
			bg = colors.bg,
			bold = true,
		},

		buffer_visible = {
			fg = colors.fgfaded,
			bg = colors.lightbg,
		},

		-- for diagnostics = "nvim_lsp"
		error = {
			fg = colors.fgfaded,
			bg = colors.lightbg,
		},
		error_diagnostic = {
			fg = colors.fgfaded,
			bg = colors.lightbg,
		},

		-- close buttons
		close_button = {
			fg = colors.fgfaded,
			bg = colors.lightbg,
		},
		close_button_visible = {
			fg = colors.fgfaded,
			bg = colors.lightbg,
		},
		close_button_selected = {
			fg = colors.red,
			bg = colors.bg,
		},
		fill = {
			fg = colors.grey_fg,
			bg = colors.lightbg,
		},
		indicator_selected = {
			fg = colors.bg,
			bg = colors.bg,
		},

		-- modified
		modified = {
			fg = colors.red,
			bg = colors.lightbg,
		},
		modified_visible = {
			fg = colors.red,
			bg = colors.lightbg,
		},
		modified_selected = {
			fg = colors.green,
			bg = colors.bg,
		},

		-- separators
		separator = {
			fg = colors.lightbg,
			bg = colors.lightbg,
		},
		separator_visible = {
			fg = colors.lightbg,
			bg = colors.lightbg,
		},
		separator_selected = {
			fg = colors.lightbg,
			bg = colors.lightbg,
		},

		-- tabs
		tab = {
			fg = colors.light_grey,
			bg = colors.bg,
		},
		tab_selected = {
			fg = colors.lightbg,
			bg = colors.blue,
		},
		tab_close = {
			fg = colors.red,
			bg = colors.bg,
		},
	},
})
