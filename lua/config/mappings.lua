local map = require("util").map
local cmd = vim.cmd

local M = {}

------------ [ Defaults ] ------------
-- Called during init
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

	-- copy entire file
	map("n", "<C-c>", ":%y+ <CR>")

	-- Do not copy the replaced text after pasting in visual mode
	-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
	map("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

	-- Do not yank text on delete ( dd )
	map({ "n", "v" }, "d", '"_d')

	-- Reselect after indent
	map("v", "<", "<gv")
	map("v", ">", ">gv")

	-- }}}
	-- [ Navigation ] -- {{{
	-- [ Within insert mode ]
	-- map("i", "<C-h>", "<Left>")
	-- map("i", "<C-l>", "<Right>")
	-- map("i", "<C-j>", "<Down>")
	-- map("i", "<C-k>", "<Up>")
	map("i", "<C-e>", "<End>") -- end of line
	map("i", "<C-a>", "<ESC>^i") -- beginning of line

	-- [ Within non-insert mode ]
	map({ "n", "v" }, "gh", "^") -- beginning of line
	map({ "n", "v" }, "gl", "$") -- end of line

	-- [ Between windows ] --
	map("n", "<C-h>", "<C-w>h")
	map("n", "<C-l>", "<C-w>l")
	map("n", "<C-k>", "<C-w>k")
	map("n", "<C-j>", "<C-w>j")

	map("n", "<leader>x", ":lua require('util').close_buffer()<CR>") -- close buffer
	map("n", "<S-t>", ":enew <CR>") -- new buffer
	map("n", "<C-t>b", ":tabnew <CR>") -- new tabs
	map("n", "<leader>n", ":set nu! <CR>") -- toggle line number

	map("n", "<leader>h", "<C-w>s") -- horizontal split
	map("n", "<leader>v", "<C-w>v") -- vertical split

	-- center cursor when moving (goto_definition)
	map("n", "<C-u>", "<C-u>zz")
	map("n", "<C-d>", "<C-d>zz")
	map("n", "n", "nzzzv")
	map("n", "N", "Nzzzv")

	-- [ Misc ] --
	-- open url under cursor
	if vim.loop.os_uname().sysname == "Darwin" then
		map("n", "gx", ":execute 'silent! !open ' . shellescape(expand('<cWORD>'), 1)<cr>")
	else
		map("n", "gx", ":execute 'silent! !xdg-open ' . shellescape(expand('<cWORD>'), 1)<cr>")
	end

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
	-- }}}
end

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
	map("n", "<leader>/", ":lua require('Comment.api').toggle.linewise.current()<CR>")
	map("v", "<leader>/", ":lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
end

M.lsp = function(_, _) -- (client, bufnr)
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

	map("n", "<leader>fs", "<cmd>lua require('config.plugins.lsp.formatting').toggle()<CR>")
end

M.nvimtree = function()
	map("n", "<C-n>", ":NvimTreeToggle <CR>")
	map("n", "<leader>tf", ":NvimTreeFindFile <CR>")
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

M.leap = function()
	map({ "n", "x", "o" }, "<leader>s", "<Plug>(leap-forward)")
	map({ "n", "x", "o" }, "<leader>S", "<Plug>(leap-backward)")
	map("x", "<leader>x", "<Plug>(leap-forward-x)")
	map("x", "<leader>X", "<Plug>(leap-backward-x)")
end

M.gitsigns = function(bufnr)
	local gs = package.loaded.gitsigns

	local function buf_map(mode, l, r, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, l, r, opts)
	end

	-- Navigation
	buf_map("n", "]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	buf_map("n", "[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true })

	-- Actions
	buf_map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
	buf_map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
	buf_map("n", "<leader>hS", gs.stage_buffer)
	buf_map("n", "<leader>hu", gs.undo_stage_hunk)
	buf_map("n", "<leader>hR", gs.reset_buffer)
	buf_map("n", "<leader>hp", gs.preview_hunk)
	buf_map("n", "<leader>hb", function()
		gs.blame_line({ full = true })
	end)
	buf_map("n", "<leader>tb", gs.toggle_current_line_blame)
	buf_map("n", "<leader>hd", gs.diffthis)
	buf_map("n", "<leader>hD", function()
		gs.diffthis("~")
	end)
	buf_map("n", "<leader>td", gs.toggle_deleted)

	-- Text object
	buf_map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

return M
