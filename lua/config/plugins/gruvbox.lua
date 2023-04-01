local M = {
	"morhetz/gruvbox",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>tl",
			function()
				vim.cmd("set background=light")
				vim.cmd.colorscheme("gruvbox")
			end,
		},
	},
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
	ViMode = {
		Normal = "#89b482",
	},
}

return M
