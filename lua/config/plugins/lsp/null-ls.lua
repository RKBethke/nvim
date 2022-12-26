local M = {
	"jose-elias-alvarez/null-ls.nvim",
}

function M.setup(options)
	local nls = require("null-ls")
	nls.setup({
		debug = false,
		save_after_format = false,
		on_attach = options.on_attach,
		sources = {
			nls.builtins.formatting.prettier.with({
				filetypes = { "markdown" },
			}),

			-- Lua
			nls.builtins.formatting.stylua,

			-- Rust
			nls.builtins.formatting.rustfmt,

			-- Shell
			nls.builtins.formatting.shfmt,
			nls.builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

			-- Gitsigns
			nls.builtins.code_actions.gitsigns,
		},
	})
end

function M.has_formatter(ft)
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	return #available > 0
end

return M
