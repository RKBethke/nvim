-- Spacing
vim.bo.expandtab = false
vim.bo.tabstop = 8
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

vim.bo.textwidth = 120
vim.bo.makeprg = 'clang++ -fobjc-arc -framework Foundation "%" -o "%:r" && ./"%:r" && rm "%:r"'
