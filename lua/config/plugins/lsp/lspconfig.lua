local Util = require("util")
return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"jose-elias-alvarez/null-ls.nvim",
		"nvim-lua/plenary.nvim",
	},
	opts = {
		-- Options for vim.diagnostic.config()
		diagnostics = {
			severity_sort = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			virtual_text = false,
			-- virtual_text = {
			-- 	spacing = 4,
			-- 	source = "if_many",
			-- 	prefix = "●",
			-- },
		},
		inlay_hint = {
			enabled = true,
		},
		capabilities = {},
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
					root_dir = Util.get_root,
					single_file_support = false,
				},
				docs = {
					description = [[
			BQN Language Server
					]],
					default_config = {
						root_dir = [[Util.get_root]],
					},
				},
			},
		},
		servers = {
			clangd = {},
			nil_ls = {},
			pyright = {},
			bqnlsp = {},
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						checkOnSave = {
							command = "clippy",
							extraArgs = { "--no-deps" },
							allTargets = false,
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
				single_file_support = true,
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
								vim.api.nvim_get_runtime_file("", true),
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
							maxPreload = 100000,
							preloadFileSize = 10000,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			},
		},
		setup = {
			-- Perform additional lsp server setup here.
		},
	},
	config = function(_, opts)
		local function on_attach(on_attach_fn)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buffer = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					on_attach_fn(client, buffer)
				end,
			})
		end
		-- [[ Autoformat ]] --
		-- TODO
		-- Util.format.register(Util.lsp.formatter())

		-- [[ Keymaps ]] --
		on_attach(function(client, buffer)
			require("config.plugins.lsp.lsp_mappings").on_attach(client, buffer)
		end)

		local register_capability = vim.lsp.handlers["client/registerCapability"]
		vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
			local ret = register_capability(err, res, ctx)
			local client_id = ctx.client_id
			---@type lsp.Client
			local client = vim.lsp.get_client_by_id(client_id)
			local buffer = vim.api.nvim_get_current_buf()
			require("config.plugins.lsp.lsp_mappings").on_attach(client, buffer)
			return ret
		end

		-- [[ Diagnostics ]] --
		local diagnostic_icons = {
			Error = "",
			Info = "",
			Hint = "",
			Warn = "",
		}
		for type, icon in pairs(diagnostic_icons) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, numhl = "", texthl = hl })
		end

		local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
		if opts.inlay_hint.enabled and inlay_hint then
			on_attach(function(client, buffer)
				if client.supports_method("textDocument/inlayHint") then
					inlay_hint(buffer, true)
				end
			end)
		end

		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

		-- [[ Servers ]] --
		local configs = opts.configs
		for config, config_opts in pairs(configs) do
			if config_opts then
				require("lspconfig.configs")[config] = config_opts
			end
		end

		local servers = opts.servers
		local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp and cmp_nvim_lsp.default_capabilities() or {},
			opts.capabilities or {}
		)

		local function setup_server(server)
			local server_opts = vim.tbl_deep_extend("force", {
				capabilities = vim.deepcopy(capabilities),
			}, servers[server] or {})

			if opts.setup[server] then
				if opts.setup[server](server, server_opts) then
					return
				end
			elseif opts.setup["*"] then
				if opts.setup["*"](server, server_opts) then
					return
				end
			end
			require("lspconfig")[server].setup(server_opts)
		end

		for server, server_opts in pairs(servers) do
			if server_opts then
				setup_server(server)
			end
		end
	end,
}
