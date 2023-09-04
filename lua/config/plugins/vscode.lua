local M = {
    "askfiy/visual_studio_code",
	priority = 100,
	lazy = false,
	keys = {
		{
			"<leader>tl",
			function()
				vim.cmd("set background=light")
				vim.cmd.colorscheme("visual_studio_code")
			end,
		},
	},
	opts = {
		mode = "light"
	}
}

M.colors = {
	fg = "#0431FA",
	bg = "#FFFFFF",
	bg_statusline = "#007ACC",
	accent = "#008000",
	lightbg = "#282828",
	fgfaded = "#616161",
	grey = "#939393",
	light_grey = "#8E8E90",
	dark_grey = "#383432",
	bright = "#fbf1c7",
	red = "#BE1100",
	green = "#008000",
	blue = "#0431FA",
	yellow = "#B89500",
	magenta = "#AF00DB",
	orange = "#e78a4e",
	cyan = "#267F99",
	ViMode = {
		Normal = "#267F99",
	},
}

return M
