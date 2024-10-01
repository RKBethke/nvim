return {
	"morhetz/gruvbox",
	lazy = true,
	config = function()
		vim.g.gruvbox_contrast_dark = "medium"
		vim.g.gruvbox_contrast_light = "medium"
		vim.g.gruvbox_bold = 0
		vim.cmd.colorscheme("gruvbox")
	end,
}
