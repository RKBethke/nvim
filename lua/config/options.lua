local opt = vim.opt
local g = vim.g

opt.confirm = true
opt.laststatus = 3
opt.title = true
opt.clipboard = "unnamedplus" -- Use the clipboard for all operations

if vim.version().minor > 7 then
	opt.cmdheight = 0
else
	opt.cmdheight = 1
end

opt.cul = true -- cursor line
opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Indentline
opt.expandtab = false
opt.tabstop = 8
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.joinspaces = false -- No double spaces with join after a dot

-- Folds
opt.foldmethod = "marker"

-- Show whitespace
opt.list = true
opt.listchars = {
	trail = "_",
	tab = "» ",
	extends = "◣",
	precedes = "◢",
	space = "·",
}
opt.fillchars = {
	foldopen = "",
	foldclose = "",
}
opt.showbreak = "↪ "

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = { eob = " " }

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

-- disable mode
opt.smd = false

opt.signcolumn = "yes"
opt.colorcolumn = "100,120"
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8

opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- Allow specified keys that move the cursor left/right to move to the
-- previous/next line when the cursor is on the first/last character in
-- the line.
opt.whichwrap:append("<>[]")

-- auto-wrap comments, don't auto insert comment on o/O and enter
opt.formatoptions:remove("cro")

-- Global editor variables:
g.mapleader = " "
