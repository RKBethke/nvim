vim.bo.expandtab = true
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

vim.bo.textwidth = 80

vim.bo.comments = ":/"
vim.bo.commentstring = "/ %s"
vim.bo.makeprg = "rho %"
vim.bo.errorformat = "%m"

-- Workaround for telescope's colorscheme picker disabling Vim's regex syntax highlighting.
local autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
	pattern = { "*.ro" },
	callback = function()
		vim.cmd("syntax enable")
		vim.cmd("syntax on")
	end,
})
