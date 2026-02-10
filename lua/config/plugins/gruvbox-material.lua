return {
	"sainnhe/gruvbox-material",
	lazy = true,
	config = function()
		vim.g.gruvbox_material_background = "medium"
		vim.g.gruvbox_material_sign_column_background = "none"
		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_ui_contrast = "hard"
	end,
}
