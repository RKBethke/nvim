local util = require("util")
return {
	"neovim/nvim-lspconfig",
	lazy = false,
	opts = {
		-- Options for vim.diagnostic.config()
		diagnostics = {
			severity_sort = true,
			signs = true,
			underline = true,
			update_in_insert = true,
			virtual_text = false,
		},
		inlay_hint = {
			enabled = false, -- Toggle mapping provided.
		},
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
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						assist = {
							importEnforceGranularity = true,
							importPrefix = "crate",
						},
						cargo = {
							allFeatures = true,
						},
						checkOnSave = {
							command = "clippy",
							extraArgs = { "--no-deps" },
							allTargets = false,
						},
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
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global.
							globals = { "vim", "use" },
						},
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
		-- Keymaps
		local function on_attach(on_attach_fn)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local buffer = args.buf
					on_attach_fn(client, buffer)
				end,
			})
		end

		on_attach(function(client, buffer)
			require("config.plugins.lsp.lsp_mappings").on_attach(client, buffer)
			client.server_capabilities.semanticTokensProvider = nil
		end)

		local register_capability = vim.lsp.handlers["client/registerCapability"]
		vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
			local ret = register_capability(err, res, ctx)
			local client = vim.lsp.get_client_by_id(ctx.client_id)
			local buffer = vim.api.nvim_get_current_buf()
			require("config.plugins.lsp.lsp_mappings").on_attach(client, buffer)
			return ret
		end

		-- Diagnostics
		local diagnostic_icons = {
			Error = "",
			Info = "",
			Hint = "",
			Warn = "",
		}
		for type, _ in pairs(diagnostic_icons) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { texthl = hl, numhl = hl, text = "" })
		end

		-- https://github.com/neovim/neovim/pull/31345
		for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
			local default_diagnostic_handler = vim.lsp.handlers[method]
			vim.lsp.handlers[method] = function(err, result, context, config)
				if err ~= nil and err.code == -32802 then
					return
				end
				return default_diagnostic_handler(err, result, context, config)
			end
		end

		-- Inlay Hints
		if opts.inlay_hint.enabled then
			on_attach(function(client, buffer)
				if client.supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
				end
			end)
		end

		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

		local lspconfig = require("lspconfig")
		local blink_cmp = require("blink.cmp")
		for server, config in pairs(opts.servers) do
			config.capabilities = blink_cmp.get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
}
