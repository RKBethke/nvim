local opt = vim.opt
local g = vim.g

-- [[ Global ]] --
g.mapleader = " "

-- [[ Options ]] --
opt.confirm = true
opt.laststatus = 3
opt.title = true
opt.clipboard = "unnamedplus" -- Use the clipboard for all operations
opt.cmdheight = 0

opt.cul = true -- Cursor line
opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

opt.inccommand = "split"
opt.jumpoptions = "view"
opt.smoothscroll = true

-- Indent
opt.expandtab = true
opt.tabstop = 8
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.joinspaces = false -- No double spaces with join after a dot
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- Folds
opt.foldmethod = "marker"

-- Whitespace
-- opt.list = true
opt.listchars = {
	trail = "_",
	extends = "»",
	precedes = "«",
	tab = "^ ",
	-- tab = "▎ "
	-- tab = "┆ ",
	-- space = "·",
}
opt.fillchars = {
	foldopen = "",
	foldclose = "",
}
opt.showbreak = "↪ "

-- Enable concealing
opt.conceallevel = 2
opt.concealcursor = "nc"

-- Disable tilde on end of buffer
opt.fillchars = { eob = " " }

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = false

-- Disable nvim intro
opt.shortmess:append("nosIT")

-- Disable mode
opt.smd = false

opt.signcolumn = "yes"
opt.colorcolumn = "+0,100,120"
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8

opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true

-- Interval for writing swap file to disk; also used by gitsigns.
opt.updatetime = 250

-- Allow specified keys that move the cursor left/right to move to the
-- previous/next line when the cursor is on the first/last character in
-- the line.
opt.whichwrap:append("<>[]")
opt.linebreak = true -- Wrap lines at convenient points

-- auto-wrap comments, don't auto insert comment on o/O and enter
-- opt.formatoptions:remove("cro")

-- Diffs
opt.diffopt:append("algorithm:histogram")
opt.diffopt:append("indent-heuristic")
