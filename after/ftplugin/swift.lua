-- Spacing
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

vim.bo.textwidth = 100
vim.bo.makeprg =
	'swiftc -strict-concurrency=complete -swift-version 6 "%" -o "%:r" && ./"%:r" && rm "%:r"'
