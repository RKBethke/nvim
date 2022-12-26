local M = {
	"L3MON4D3/LuaSnip",
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}

function M.config()
	local luasnip = require("luasnip")
	local types = require("luasnip.util.types")

	luasnip.config.setup({
		history = true,
		updateevents = "TextChanged,TextChangedI",
		enable_autosnippets = true,
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { " <- Current Choice", "NonTest" } },
				},
			},
		},
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
end

return M
