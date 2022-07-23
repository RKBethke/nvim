local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {
	-- Web development
	b.formatting.prettierd.with({ filetypes = { "html", "markdown", "css" } }),

	-- Lua
	b.formatting.stylua.with({
		-- Only format if there is a stylua.toml file
		condition = function(utils)
			return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
		end,
	}),

	-- Shell
	b.formatting.shfmt,
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

	-- Gitsigns
	b.code_actions.gitsigns,
}

local M = {}

M.setup = function()
	null_ls.setup({
		debug = true,
		sources = sources,
	})
end

return M
