return {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = "./snippets" })
		end,
	},
	config = function()
		local luasnip = require("luasnip")

		luasnip.config.setup({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})

		-- Expansion Key:
		-- Expand the current item or jump to the next item within the snippet.
		vim.keymap.set({ "i", "s" }, "<M-j>", function()
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { silent = true })

		-- Jump backwards key:
		-- Moves to the previous item within the snippet
		vim.keymap.set({ "i", "s" }, "<M-k>", function()
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { silent = true })
	end,
}
