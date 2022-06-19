local present, impatient = pcall(require, "impatient")

if present then
	impatient.enable_profile()
end

-- experimental filetype.lua
-- This will exclusively use filetype.lua for filetype matching
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

local ok, err = pcall(require, "core")

if not ok then
	error("Error: " .. err)
end
