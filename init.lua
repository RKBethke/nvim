--[[
	init.lua
	The entry point into my neovim configuration.
--]]

local util = require("util")
local require = util.require

require("config.options")
require("config.autocmds")
require("config.lazy")

local bg = util.is_dark_mode() and "dark" or "light"
local cs = util.is_dark_mode() and "lackluster-night" or "gruvbox"
vim.cmd("set background=" .. bg)
vim.cmd.colorscheme(cs)

util.on_very_lazy(function()
	require("config.mappings").defaults()
	require("ui").setup()

	util.display_version()
end)
