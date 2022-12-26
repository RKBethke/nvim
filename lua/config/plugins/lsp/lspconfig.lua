local M = {
	"neovim/nvim-lspconfig",
	name = "lsp",
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"jose-elias-alvarez/null-ls.nvim",
		"nvim-lua/plenary.nvim",
	},
}

function M.config()
	require("config.plugins.lsp.diagnostics").setup()

	local function on_attach(client, bufnr)
		require("config.plugins.lsp.formatting").setup(client, bufnr)
		require("config.mappings").lsp(client, bufnr)
	end

	-- credits to @Malace : https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
	-- This is modified version of the above snippet
	vim.lsp.buf.rename = {
		float = function()
			local currName = vim.fn.expand("<cword>") .. " "

			local win = require("plenary.popup").create(currName, {
				title = "Rename",
				style = "minimal",
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				relative = "cursor",
				borderhighlight = "RenamerBorder",
				titlehighlight = "RenamerTitle",
				focusable = true,
				width = 25,
				height = 1,
				line = "cursor+2",
				col = "cursor-1",
			})

			local map_opts = { noremap = true, silent = true }

			vim.cmd("normal w")
			vim.cmd("startinsert")

			vim.api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
			vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
			vim.api.nvim_buf_set_keymap(
				0,
				"i",
				"<CR>",
				"<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
				map_opts
			)
			vim.api.nvim_buf_set_keymap(
				0,
				"n",
				"<CR>",
				"<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
				map_opts
			)
		end,

		apply = function(curr, win)
			local newName = vim.trim(vim.fn.getline("."))
			vim.api.nvim_win_close(win, true)

			if #newName > 0 and newName ~= curr then
				local params = vim.lsp.util.make_position_params()
				params.newName = newName

				vim.lsp.buf_request(0, "textDocument/rename", params)
			end
		end,
	}

	local servers = {
		clangd = {},
		nil_ls = {},
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
		sumneko_lua = {
			single_file_support = true,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim", "use" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
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
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	local options = {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}

	for server, opts in pairs(servers) do
		opts = vim.tbl_deep_extend("force", {}, options, opts or {})
		require("lspconfig")[server].setup(opts)
	end

	require("config.plugins.lsp.null-ls").setup(options)
end

return M
