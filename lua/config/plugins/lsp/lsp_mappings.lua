local M = {}

M.on_attach = function(_, bufnr) -- (client, bufnr)
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	local map = require("util").map
	map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")

	if ft ~= "supercollider" then
		map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	end

	map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
	map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename.float()<CR>")
	map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	map("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
	map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
	map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
	-- map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
	--
	-- map("n", "<leader>fs", "<cmd>lua require('config.plugins.lsp.formatting').toggle()<CR>")
end

return M
