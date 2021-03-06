local core_modules = {
	"core.utils",
	"core.options",
	"core.autocmds",
	"core.mappings",
}

for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end

-- Load mappings which are not plugin related
require("core.mappings").defaults()

-- Load theme
require("colors")
