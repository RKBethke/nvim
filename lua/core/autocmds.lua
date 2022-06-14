local autocmd = vim.api.nvim_create_autocmd

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

-- Don't show any numbers inside terminals
-- TODO: switch to use new autocmd api
vim.cmd([[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]])

-- Highlight yanked text
-- autocmd("TextYankPost", {
--    callback = function()
--       vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
--    end,
-- })
