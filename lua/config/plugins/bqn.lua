return {
	"mlochbaum/BQN",
	dependencies = {
		url = "https://git.sr.ht/~detegr/nvim-bqn",
	},
	ft = "bqn",
	config = function(plugin)
		vim.opt.rtp:append(plugin.dir .. "/editors/vim")

		-- Override highlighting for: "←⇐↩→" characters.
		local override_bqn_highlight = function()
			vim.api.nvim_set_hl(0, "bqnarw", { link = "keyword" })
		end

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			pattern = { "*.bqn" },
			callback = override_bqn_highlight,
		})

		vim.api.nvim_create_autocmd("BufWinEnter", {
			pattern = "*",
			callback = override_bqn_highlight,
		})
	end,
}
