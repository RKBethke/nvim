local M = {}

M.on_attach = function(_, bufnr) -- (client, bufnr)
	-- See `:help vim.lsp.*` for documentation on any of the below functions.
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	local set = vim.keymap.set
	set("n", "gD", vim.lsp.buf.declaration)
	set("n", "gd", vim.lsp.buf.definition)

	if ft ~= "supercollider" then
		set("n", "K", vim.lsp.buf.hover)
	end

	set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
	set("n", "gk", vim.lsp.buf.signature_help, { desc = "Signature Help" })
	set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
	set(
		"n",
		"<leader>wr",
		vim.lsp.buf.remove_workspace_folder,
		{ desc = "Remove Workspace Folder" }
	)
	set(
		"n",
		"<leader>wl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		{ desc = "List Workspace Folders" }
	)
	set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type Definition" })
	set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
	set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
	set("n", "gr", vim.lsp.buf.references, { desc = "References" })
	set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set loclist" })

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
