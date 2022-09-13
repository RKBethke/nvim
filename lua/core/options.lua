local opt = vim.opt
local g = vim.g

opt.confirm = true
opt.laststatus = 3
opt.title = true
opt.clipboard = "unnamedplus" -- To ALWAYS use the clipboard for ALL operations

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
opt.shiftwidth = 4
opt.smartindent = true

-- Folds
opt.foldmethod = "marker"

-- Show whitespace
opt.list = true
opt.listchars = {
	trail = '~',
	tab = '> ',
	extends = '◣',
	precedes = '◢'
}

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
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
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
opt.formatoptions:remove "cro"

-- Global editor variables:
g.mapleader = " "

-- disable some builtin vim plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"python3_provider",
	"python_provider",
	"node_provider",
	"ruby_provider",
	"perl_provider",
	"tutor",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end

-- set shada path
vim.schedule(function()
	vim.opt.shadafile = vim.fn.expand("$HOME") .. "/.local/share/nvim/shada/main.shada"
	vim.cmd([[ silent! rsh ]])
end)
