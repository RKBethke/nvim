--[[
	init.lua
	The entry point into my neovim configuration.
--]]

require("impatient")

local ok, err = pcall(require, "core")

if not ok then
	error("Error: " .. err)
end
