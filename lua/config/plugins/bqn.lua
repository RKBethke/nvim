return {
	"mlochbaum/BQN",
	dependencies = {
		url = "https://git.sr.ht/~detegr/nvim-bqn",
	},
	ft = "bqn",
	config = function(plugin)
		vim.opt.rtp:append(plugin.dir .. "/editors/vim")

		-- Override highlighting for: "←⇐↩→" characters after plugin has loaded.
		vim.api.nvim_create_autocmd("VimEnter", {
			pattern = { "*.bqn" },
			command = "hi link bqnarw keyword",
		})
	end,
}
