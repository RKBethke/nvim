local autocmd = vim.api.nvim_create_autocmd
local usrcmd = vim.api.nvim_create_user_command

usrcmd("Dark", "set background=dark", {})
usrcmd("Light", "set background=light", {})
usrcmd("CopyPath", "let @+ = expand('%:p')", {})

-- Don't show any numbers inside terminals.
autocmd("TermOpen", {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.filetype = "terminal"
	end,
})

-- Save the cursor position and important marks.
autocmd("BufWritePre", {
	callback = function()
		local original_cursor = vim.fn.getcurpos()
		local first_changed = vim.fn.getpos("'[")
		local last_changed = vim.fn.getpos("']")
		vim.cmd("silent exe '%s/\\v\\s+$//e'")

		vim.fn.setpos("']", last_changed)
		vim.fn.setpos("'[", first_changed)
		vim.fn.setpos(".", original_cursor)
	end,
})

-- Open file at the last position it was edited earlier.
autocmd("BufReadPost", {
	callback = function()
		local m = vim.api.nvim_buf_get_mark(0, '"')
		if m[1] > 1 and m[1] <= vim.api.nvim_buf_line_count(0) then
			vim.api.nvim_win_set_cursor(0, m)
		end
	end,
})
