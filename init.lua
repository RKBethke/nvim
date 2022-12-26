--[[
	init.lua
	The entry point into my neovim configuration.
--]]

local util = require("util")
local require = util.require

require("config.options")
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		util.display_version()
		require("config.autocmds")
		require("config.mappings").defaults()
	end,
})
