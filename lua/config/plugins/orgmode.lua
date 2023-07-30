return {
	"nvim-orgmode/orgmode",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"lukas-reineke/headlines.nvim",
		"akinsho/org-bullets.nvim",
	},
	init = function()
		require("orgmode").setup_ts_grammar()
		require("orgmode").setup({
			org_agenda_files = { "~/org/*" },
			org_hide_emphasis_markers = true,
			org_default_notes_file = "~/org/refile.org",
		})
	end,
	config = function()
		require("headlines").setup()
		require("org-bullets").setup()
	end,
}
