local present, ls = pcall(require, "luasnip")
if not present then
	return
end
local types = require("luasnip.util.types")

ls.config.set_config({
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

require("luasnip/loaders/from_vscode").lazy_load()

-- Expansion Key:
-- Expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<M-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

-- Jump backwards key:
-- Moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<M-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })
