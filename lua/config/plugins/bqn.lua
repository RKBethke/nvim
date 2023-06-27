return {
	"mlochbaum/BQN",
	dependencies = {
		url = "https://git.sr.ht/~detegr/nvim-bqn",
	},
	ft = "bqn",
	config = function(plugin)
		vim.opt.rtp:append(plugin.dir .. "/editors/vim")
	end,
}
