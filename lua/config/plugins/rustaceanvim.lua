return {
	"mrcjkb/rustaceanvim",
	version = "^6",
	lazy = false,
	config = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(client, bufnr)
					-- Default lsp mappings.
					require("config.plugins.lsp.lsp_mappings").on_attach(client, bufnr)

					-- rustaceanvim keymaps.
					local set = vim.keymap.set
					local bufopts = { noremap = true, silent = true, buffer = bufnr }
					set("n", "K", ":RustLsp hover actions<CR>", bufopts)
					set("n", "<leader>rd", ":RustLsp renderDiagnostic<CR>", bufopts)
					set("n", "J", ":RustLsp joinLines<CR>", bufopts)
					set("n", "<leader>ca", ":RustLsp codeAction<CR>", bufopts)
					set("n", "<leader>dbg", ":RustLsp debuggables<CR>", bufopts)
				end, -- on_attach
				default_settings = {
					["rust-analyzer"] = {
						assist = {
							importEnforceGranularity = true,
							importPrefix = "crate",
						},
						cargo = { allFeatures = true },
						check = { command = "clippy" },
						inlayHints = { locationLinks = false },
						diagnostics = {
							enable = true,
							experimental = {
								enable = true,
							},
						},
					},
				},
			},
		}
	end,
}
