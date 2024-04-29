return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▎" },
			topdelete = { text = "▎" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns
			local function buf_map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
			end

			buf_map("n", "]h", gs.next_hunk, "Next Hunk")
			buf_map("n", "[h", gs.prev_hunk, "Prev Hunk")
			buf_map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
			buf_map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
			buf_map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
			buf_map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
			buf_map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
			buf_map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
			buf_map("n", "<leader>ghb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")
			buf_map("n", "<leader>ghd", gs.diffthis, "Diff This")
			buf_map("n", "<leader>ghD", function()
				gs.diffthis("~")
			end, "Diff This ~")
			buf_map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle Current Line Blame")
			buf_map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
		end,
	},
}
