return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
		end,
	},
	config = function()
		local ls = require("luasnip")
		local types = require("luasnip.util.types")

		ls.config.setup({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			-- Visual indicator for active snippet nodes.
			enable_autosnippets = true,
			ext_opts = {
				[types.insertNode] = {
					active = {
						virt_text = { { "", "DiagnosticHint" } },
					},
				},
				[types.choiceNode] = {
					active = {
						virt_text = { { "", "DiagnosticWarn" } },
					},
				},
			},
		})

		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			else
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("<Tab>", true, true, true),
					"n",
					true
				)
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		-- Exit snippet mode cleanly
		vim.keymap.set({ "i", "s" }, "<C-s>", function()
			ls.unlink_current()
		end, { silent = true })
	end,
}
