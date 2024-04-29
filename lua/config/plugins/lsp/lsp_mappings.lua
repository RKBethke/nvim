local M = {}

M.on_attach = function(_, bufnr) -- (client, bufnr)
	-- See `:help vim.lsp.*` for documentation on any of the below functions.
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	local map = require("util").map
	map("n", "gD", vim.lsp.buf.declaration)
	map("n", "gd", vim.lsp.buf.definition)

	if ft ~= "supercollider" then
		map("n", "K", vim.lsp.buf.hover)
	end

	map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
	map("n", "gk", vim.lsp.buf.signature_help, { desc = "Signature Help" })
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add Workspace Folder" })
	map(
		"n",
		"<leader>wr",
		vim.lsp.buf.remove_workspace_folder,
		{ desc = "Remove Workspace Folder" }
	)
	map(
		"n",
		"<leader>wl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		{ desc = "List Workspace Folders" }
	)
	map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type Definition" })
	map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
	map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
	map("n", "gr", vim.lsp.buf.references, { desc = "References" })
	map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set loclist" })

	-- Diagnostics
	local diagnostic_goto = function(next, severity)
		local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
		severity = severity and vim.diagnostic.severity[severity] or nil
		return function()
			go({ severity = severity })
		end
	end
	map("n", "ge", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
	map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
	map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
	map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
	map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

	-- Note: Formatting handled by conform.nvim.
	-- map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")

	-- Note: Loclist population handled by trouble.nvim
	-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
	-- 	callback = function()
	-- 		vim.diagnostic.setloclist({ open = false })
	-- 		vim.diagnostic.setqflist({ open = false })
	-- 	end,
	-- })
end

return M
