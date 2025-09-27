local util = require("util")
return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },
	lazy = false,
	opts = {
		capabilities = {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			},
		},
		-- Options for vim.lsp.buf.format
		format = {
			formatting_options = nil,
			timeout_ms = nil,
		},
		-- LSP Server Settings
		configs = {
			bqnlsp = {
				default_config = {
					cmd = { "bqnlsp" },
					cmd_env = {},
					filetypes = { "bqn" },
					root_dir = util.get_root,
					single_file_support = false,
				},
				docs = {
					description = [[
			BQN Language Server
					]],
					default_config = {
						root_dir = [[util.get_root]],
					},
				},
			},
		},
		servers = {
			clangd = {},
			nil_ls = {},
			pyright = {},
			bqnlsp = {},
			sourcekit = {},
			hls = {
				settings = {
					haskell = {
						formattingProvider = "fourmolu",
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						-- Get the language server to recognize the `vim` global.
						diagnostics = { globals = { "vim", "use" } },
						workspace = {
							-- Make the server aware of Neovim runtime files.
							library = {
								vim.fn.expand("$VIMRUNTIME/lua"),
								vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
							checkThirdParty = false,
						},
						codeLens = { enable = true },
						telemetry = { enable = false },
						completion = { callSnippet = "Replace" },
					},
				},
			},
		},
	},
	config = function(_, opts)
		vim.diagnostic.config({
			severity_sort = true,
			underline = true,
			update_in_insert = true,
			virtual_text = false,
			virtual_lines = false,
			signs = {
				numhl = {
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				},
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
		})

		-- Keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local buffer = ev.buf
				require("config.plugins.lsp.lsp_mappings").on_attach(client, buffer)
			end,
		})

		local register_capability = vim.lsp.handlers["client/registerCapability"]
		vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
			local ret = register_capability(err, res, ctx)
			local client = vim.lsp.get_client_by_id(ctx.client_id)
			local buffer = vim.api.nvim_get_current_buf()
			require("config.plugins.lsp.lsp_mappings").on_attach(client, buffer)
			return ret
		end

		for server, config in pairs(opts.servers) do
			vim.lsp.config(server, config)
		end
	end,
}
