return {
	"RKBethke/k.nvim",
	ft = "k",
	keys = {
		{
			"<CR>",
			mode = { "n", "x", "o" },
			ft = "k",
			function()
				require("k").eval()
			end,
			desc = "Evaluate k buffer",
		},
		{
			"<CR>",
			mode = { "v" },
			ft = "k",
			function()
				require("k").eval_selection()
			end,
			desc = "Evaluate selected k lines",
		},
		{
			"<M-L>",
			mode = { "i", "n", "x", "o", "v" },
			ft = "k",
			function()
				require("k").outbuf_clear()
			end,
			desc = "Clear k output buffer",
		},
		{
			"<M-CR>",
			mode = { "n", "x", "o", "v" },
			ft = "k",
			function()
				require("k").outbuf_toggle()
			end,
			desc = "Show/hide the output buffer",
		},
	},
	opts = {},
}
