local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

local opts = {
	defaults = { lazy = true },
	install = { colorscheme = { "gruvbox-material" } },
	checker = {
		enabled = true,
		notify = false,
	},
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
	performance = {
		rtp = {
			paths = {
				"~/.local/share/nvim/site",
			},
			disabled_plugins = {
				"2html",
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
				"spellfile",
				"fzf",
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
			},
		},
	},
}

-- Load lazy
require("lazy").setup("config.plugins", opts)
