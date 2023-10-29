local M = {
	"nvimtools/none-ls.nvim"
}

function M.setup(options)
	local nls = require("null-ls")
	nls.setup({
		debug = false,
		save_after_format = false,
		on_attach = options.on_attach,
		sources = {
			-- Rust
			nls.builtins.formatting.rustfmt,

			nls.builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

			-- Gitsigns
			nls.builtins.code_actions.gitsigns,

			-- Prose
			nls.builtins.diagnostics.vale,
		},
	})
end

function M.has_formatter(ft)
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	return #available > 0
end

return M
