local util = require("util")

local M = {}

M.autoformat = true

function M.toggle()
	M.autoformat = not M.autoformat
	if M.autoformat then
		util.info("LSP: Format On Save - Enabled", "Formatting")
	else
		util.warn("LSP: Format On Save - Disabled", "Formatting")
	end
end

function M.format()
	if M.autoformat then
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		else
			vim.lsp.buf.formatting_sync()
		end
	end
end

function M.setup(client, bufnr)
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	local nls = require("config.plugins.lsp.null-ls")

	local enable = false
	if nls.has_formatter(ft) then
		enable = client.name == "null-ls"
	else
		enable = not (client.name == "null-ls")
	end

	if client.name == "tsserver" then
		enable = false
	end

	-- util.info(client.name .. " " .. (enable and "yes" or "no"), "format")

	client.server_capabilities.documentFormattingProvider = enable
	-- Format on save
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd([[
			augroup LspFormat
			autocmd! * <buffer>
			autocmd BufWritePre <buffer> lua require("config.plugins.lsp.formatting").format()
			augroup END
		]])
	end
end

return M