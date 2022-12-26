local autocmd = vim.api.nvim_create_autocmd

-- Don't show any numbers inside terminals
autocmd("TermOpen", {
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.filetype = "terminal"
	end,
})

autocmd("BufWritePre", {
	callback = function()
		-- Keep the cursor position and these marks:
		local original_cursor = vim.fn.getcurpos()
		local first_changed = vim.fn.getpos("'[")
		local last_changed = vim.fn.getpos("']")
		vim.cmd("silent exe '%s/\\v\\s+$//e'")

		vim.fn.setpos("']", last_changed)
		vim.fn.setpos("'[", first_changed)
		vim.fn.setpos('.', original_cursor)
	end,
})

-- Fix luasnip jumping erratically when not in insert mode
-- autocmd("InsertLeave", {
-- 	callback = function()
-- 		if
-- 			require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
-- 			and not require("luasnip").session.jump_active
-- 		then
-- 			require("luasnip").unlink_current()
-- 		end
-- 	end,
-- })

-- Uncomment this if you want to open nvim with a dir
-- autocmd("BufEnter", {
--    callback = function()
--       if vim.api.nvim_buf_get_option(0, "buftype") ~= "terminal" then
--          vim.cmd "lcd %:p:h"
--       end
--    end,
-- })

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
-- autocmd("InsertEnter", {
--    callback = function()
--       vim.opt.relativenumber = false
--    end,
-- })

-- autocmd("InsertLeave", {
--    callback = function()
--       vim.opt.relativenumber = true
--    end,
-- })
