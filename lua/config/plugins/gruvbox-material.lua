local M = {
	"sainnhe/gruvbox-material",
	priority = 1000,
	lazy = true,
	keys = {
		{
			"<leader>ud",
			function()
				vim.cmd("set background=dark")
				vim.cmd.colorscheme("gruvbox-material")
			end,
			desc = "Dark colorscheme",
		},
		{
			"<leader>ul",
			function()
				vim.cmd("set background=light")
				vim.cmd.colorscheme("gruvbox-material")
			end,
			desc = "Light colorscheme",
		},
	},
	config = function()
		vim.g.gruvbox_material_background = "medium"
		vim.g.gruvbox_material_enable_bold = 1
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_sign_column_background = "none"
		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_ui_contrast = "hard"
		vim.cmd.colorscheme("gruvbox-material")
	end,
}

M.colors = {
	fg = "#ddc7a1",
	bg = "#1d2021",
	bg_statusline = "#282828",
	accent = "#89b482",
	lightbg = "#282828",
	fgfaded = "#a89984",
	grey = "#928374",
	light_grey = "#a89984",
	dark_grey = "#383432",
	bright = "#fbf1c7",
	red = "#ea6962",
	green = "#a9b665",
	blue = "#7daea3",
	yellow = "#d8a657",
	magenta = "#d3869b",
	orange = "#e78a4e",
	cyan = "#89b482",
}

return M
