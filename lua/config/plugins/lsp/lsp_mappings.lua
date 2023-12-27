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

	map("n", "gi", vim.lsp.buf.implementation)
	map("n", "gk", vim.lsp.buf.signature_help)
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
	map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
	map("n", "<leader>D", vim.lsp.buf.type_definition)
	map("n", "<leader>rn", vim.lsp.buf.rename)
	map("n", "<leader>ca", vim.lsp.buf.code_action)
	map("n", "gr", vim.lsp.buf.references)
	map("n", "<leader>q", vim.diagnostic.setloclist)

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

	-- Formatting now handled by conform.nvim.
	-- map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
end

return M
