local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {
	-- Web development
	-- b.formatting.prettier.with({ filetypes = { "html", "markdown", "css" } }),
	b.formatting.prettier,

	-- Lua
	b.formatting.stylua,

	-- Rust
	b.formatting.rustfmt,

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
