return {
	"davidgranstrom/scnvim",
	ft = "supercollider",
	dependencies = "L3MON4D3/LuaSnip",
	config = function()
		local scnvim = require("scnvim")
		local map = scnvim.map
		local map_expr = scnvim.map_expr

		scnvim.setup({
			keymaps = {
				["<C-e>"] = map("editor.send_line", "n"),
				["<M-e>"] = {
					map("editor.send_block", { "i", "n" }),
					map("editor.send_selection", "x"),
				},
				["<CR>"] = map("postwin.toggle"),
				["<M-CR>"] = map("postwin.toggle", "i"),
				["<M-L>"] = map("postwin.clear", { "n", "i" }),
				["<C-k>"] = map("signature.show", { "n", "i" }),
				["<C-.>"] = map("sclang.hard_stop", { "n", "x", "i" }),
				["<F5>"] = map("sclang.start"),
				["<S-F5>"] = map_expr("s.waitForBoot { s.volume = -12 }"),
				["<F6>"] = map("sclang.stop"),
			},
			editor = {
				highlight = {
					color = "SCNvimEval",
				},
			},
			postwin = {
				horizontal = true,
				-- float = {
				-- 	enabled = true,
				-- },
			},
			snippet = {
				engine = {
					name = "luasnip",
					options = {
						descriptions = true,
					},
				},
			},
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = { "*.scd" },
			callback = function()
				require("scnvim").start()
			end,
		})
	end,
}
