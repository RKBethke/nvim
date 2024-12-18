local M = {}

M.on_attach = function(_, bufnr)
	local ft = vim.api.nvim_get_option_info2("filetype", { buf = bufnr })
	local set = vim.keymap.set

	set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
	set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
	set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
	set("n", "gr", vim.lsp.buf.references, { desc = "References" })
	set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
	set("n", "gk", vim.lsp.buf.signature_help, { desc = "Signature Help" })
	if ft ~= "supercollider" then
		set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
	end
	set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type Definition" })
	set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
	set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
	set("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Code Lens" })
	set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set loclist" })
	set("n", "<leader>h", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, { desc = "Toggle Inlay Hint" })

	-- Diagnostics
	local diagnostic_goto = function(next, severity)
		local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
		severity = severity and vim.diagnostic.severity[severity] or nil
		return function()
			go({ severity = severity })
		end
	end
	set("n", "ge", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
	set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
	set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
	set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
	set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

	-- Note: Formatting handled by conform.nvim.
	-- set("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")

	-- Note: Loclist population handled by trouble.nvim
	-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
	-- 	callback = function()
	-- 		vim.diagnostic.setloclist({ open = false })
	-- 		vim.diagnostic.setqflist({ open = false })
	-- 	end,
	-- })
end

return M
