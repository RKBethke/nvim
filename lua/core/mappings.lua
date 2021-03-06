local map = rb.map
local cmd = vim.cmd

local M = {}

--------------------------------------
------------ [ Defaults ] ------------
-- Will only be called during init
--------------------------------------
M.defaults = function()
	-- [ General ] -- {{{
	-- Easy quit
	map("n", "<leader>qa", "<cmd>qall<CR>")

	-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
	-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
	-- empty mode is same as using :map
	-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
	map({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
	map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

	-- use ESC to turn off search highlighting
	map("n", "<Esc>", ":noh <CR>")

	-- center cursor when moving (goto_definition)
	map("n", "n", "nzzzv")
	map("n", "N", "Nzzzv")

	-- copy entire file
	map("n", "<C-c>", ":%y+ <CR>")

	-- Do not copy the replaced text after pasting in visual mode
	-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
	map("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

	-- Do not yank text on cut ( x )
	-- map({ "n", "v" }, "x", '"_x')

	-- Do not yank text on delete ( dd )
	map({ "n", "v" }, "d", '"_d')

	-- }}}
	-- [ Navigation ] -- {{{
	-- [ Within insert mode ]
	map("i", "<C-h>", "<Left>")
	map("i", "<C-l>", "<Right>")
	map("i", "<C-j>", "<Down>")
	map("i", "<C-k>", "<Up>")
	map("i", "<C-e>", "<End>") -- end of line
	map("i", "<C-a>", "<ESC>^i") -- beginning of line

	-- [ Between windows ] --
	map("n", "<C-h>", "<C-w>h")
	map("n", "<C-l>", "<C-w>l")
	map("n", "<C-k>", "<C-w>k")
	map("n", "<C-j>", "<C-w>j")

	map("n", "<leader>x", ":lua rb.close_buffer() <CR>") -- close buffer
	map("n", "<S-t>", ":enew <CR>") -- new buffer
	map("n", "<C-t>b", ":tabnew <CR>") -- new tabs
	map("n", "<leader>n", ":set nu! <CR>") -- toggle line number

	map("n", "<leader>h", "<C-w>s") -- horizontal split
	map("n", "<leader>v", "<C-w>v") -- vertical split

	-- [ Misc ] --
	map("n", "gx", ":!xdg-open <c-r><c-a><CR>") -- open url under cursor

	-- }}}
	-- [ Terminal] -- {{{
	map("t", "jk", "<C-\\><C-n>") -- escape terminal mode
	map("t", "JK", "<C-\\><C-n> :lua rb.close_buffer() <CR>") -- hide a termingal from within terminal mode
	map("n", "<leader>H", ":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>") -- new horizontal
	map("n", "<leader>V", ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>") -- new vertical
	map("n", "<leader>W", ":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>") --  new window
	map("t", ":q!", "<C-\\><C-n>:q!<CR>") -- :q quits terminal
	-- }}}
	-- [ Commands ] -- {{{
	cmd("silent! command CopyPath let @+ = expand('%:p')")

	-- [ Packer ] --
	-- Add Packer commands because we are not loading it at startup
	cmd("silent! command PackerClean lua require 'plugins' require('packer').clean()")
	cmd("silent! command -nargs=* PackerCompile lua require 'plugins' require('packer').compile(<q-args>)")
	cmd("silent! command PackerProfile lua require 'plugins' require('packer').profile_output()")
	cmd("silent! command PackerInstall lua require 'plugins' require('packer').install()")
	cmd("silent! command PackerStatus lua require 'plugins' require('packer').status()")
	cmd("silent! command PackerSync lua require 'plugins' require('packer').sync()")
	cmd("silent! command PackerUpdate lua require 'plugins' require('packer').update()")
	-- }}}
end

-------------------------------------
------------ [ Plugins ] ------------
-- All plugin related mappings
-------------------------------------
M.bufferline = function()
	map("n", "L", ":BufferLineCycleNext <CR>")
	map("n", "H", ":BufferLineCyclePrev <CR>")
	map("n", "<A-L>", ":BufferLineMoveNext <CR>")
	map("n", "<A-H>", ":BufferLineMovePrev <CR>")
end

M.comment = function()
	map("n", "<leader>/", ":lua require('Comment.api').toggle_current_linewise()<CR>")
	map("v", "<leader>/", ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")
end

M.lspconfig = function()
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	map("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
	map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename.float()<CR>")
	map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	map("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
	map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
	map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
	map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")

	map("n", "<leader>fs", ":LSPToggleFormatOnSave <CR>")
end

M.lsp_lines = function()
	map("n", "<leader>l", ":lua require('lsp_lines').toggle()<CR>")
end

M.nvimtree = function()
	map("n", "<C-n>", ":NvimTreeToggle <CR>")
	map("n", "<leader>e", ":NvimTreeFocus <CR>")
end

M.telescope = function()
	map("n", "<leader>fb", ":Telescope buffers <CR>")
	map("n", "<leader>ff", ":Telescope find_files <CR>")
	map("n", "<leader>fa", ":Telescope find_files no_ignore=true hidden=true <CR>")
	map("n", "<leader>cm", ":Telescope git_commits <CR>")
	map("n", "<leader>gt", ":Telescope git_status <CR>")
	map("n", "<leader>fh", ":Telescope help_tags <CR>")
	map("n", "<leader>fw", ":Telescope live_grep <CR>")
	map("n", "<leader>fo", ":Telescope oldfiles <CR>")
	map("n", "<leader>tk", ":Telescope keymaps <CR>")
	map("n", "<leader><leader>", ":Telescope resume <CR>")
end

return M
