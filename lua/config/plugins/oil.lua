return {
	"stevearc/oil.nvim",
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			mode = "n",
			desc = "Open parent directory",
		},
		{
			"<leader>-",
			function()
				require("oil").toggle_float()
			end,
			mode = "n",
			desc = "Open parent directory",
		},
	},
	opts = {
		columns = { "icon" },
		keymaps = {
			["<C-h>"] = false,
			["<M-h>"] = "actions.select_split",
		},
		view_options = {
			show_hidden = true,
		},
	},
}
