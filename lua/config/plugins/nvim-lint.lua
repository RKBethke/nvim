return {
	"mfussenegger/nvim-lint",
	event = "VeryLazy",
	opts = {
		events = {  "BufReadPost", "BufWritePost","InsertLeave" },
		linters_by_ft = {
			sh = { "shellcheck" },
			markdown = { "vale" },
		},
		linters = {

		},
	},
	config = function(_, opts)
		local lint = require("lint")
		for name, linter in pairs(opts.linters) do
			if type(linter) == "table" and type(lint.linters[name]) == "table" then
				lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
			else
				lint.linters[name] = linter
			end
		end
		lint.linters_by_ft = opts.linters_by_ft

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = function() require("lint").try_lint() end
		})
		require("lint").try_lint()
	end,
}
