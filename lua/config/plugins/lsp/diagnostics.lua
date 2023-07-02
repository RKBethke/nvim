local M = {}

M.signs = {
	Error = "",
	Info = "",
	Hint = "",
	Warn = "",
}

function M.setup()
	vim.diagnostic.config({
		severity_sort = true,
		signs = true,
		underline = true,
		update_in_insert = false,
		virtual_text = false,
		-- virtual_text = { spacing = 4, prefix = "●" },
	})

	local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
	local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "single",
		max_width = max_width,
		max_height = max_height,
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "single",
		focusable = false,
		relative = "cursor",
		max_width = max_width,
		max_height = max_height,
	})

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		underline = true,
		signs = true,
	})

	vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
		local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
		pcall(vim.diagnostic.reset, ns)
		return true
	end

	local function lsp_symbol(type, icon)
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
	end

	for type, icon in pairs(M.signs) do
		lsp_symbol(type, icon)
	end
end

return M
