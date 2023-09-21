--[[
	init.lua
	The entry point into my neovim configuration.
--]]

local util = require("util")
local require = util.require

require("config.options")
require("config.lazy")

util.on_very_lazy(function()
	util.display_version()
	require("config.autocmds")
	require("config.mappings").defaults()
	require("ui").setup()
end)
