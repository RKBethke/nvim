local map = require("util").map

local M = {}

------------ [ Defaults ] ------------
-- Called during init               --
--------------------------------------
M.defaults = function()
	-- [ General ] -- {{{
	-- Easy quit
	map("n", "<leader>qa", "<cmd>qall<CR>", { desc = "Quit all" })

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
	-- map({ "n", "v" }, "d", '"_d')

	-- Reselect after indent
	map("v", "<", "<gv")
	map("v", ">", ">gv")

	-- Print current date
	map("n", "<leader>cd", "<cmd>put =strftime('%Y-%m-%d')<cr>", { desc = "Paste current date" })
	map(
		"n",
		"<leader>cD",
		"<cmd>put =strftime('%a %Y-%m-%d %H:%M:%S%z')<cr>",
		{ desc = "Paste current date (verbose)" }
	)

	-- }}}
	-- [ Navigation ] -- {{{
	-- [ Within insert mode ]
	-- map("i", "<C-h>", "<Left>")
	-- map("i", "<C-l>", "<Right>")
	-- map("i", "<C-j>", "<Down>")
	-- map("i", "<C-k>", "<Up>")
	map("i", "<C-a>", "<ESC>^i", { desc = "Go to beginning of line" })
	map("i", "<C-e>", "<End>", { desc = "Go to end of line" })

	-- [ Within non-insert mode ] --
	map({ "n", "v" }, "gh", "^", { desc = "Go to beginning of line" })
	map({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })

	-- [ Between windows ] --
	map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
	map("n", "<C-l>", "<C-w>l", { desc = "Go to lower window" })
	map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
	map("n", "<C-j>", "<C-w>j", { desc = "Go to right window" })

	map("n", "<leader>wh", "<C-w>s", { desc = "Horizonal split" })
	map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })

	map("n", "<leader>x", ":lua require('util').close_buffer()<CR>", { desc = "Close Buffer" })
	map("n", "<S-t>", ":enew <CR>", { desc = "New buffer" })
	map("n", "<C-t>b", ":tabnew <CR>", { desc = "New tab" })
	map("n", "H", ":bprev<CR>", { desc = "Switch to previous buffer" })
	map("n", "L", ":bnext<CR>", { desc = "Switch to next buffer" })

	-- [ UI ] --
	map("n", "<leader>un", ":set nu! <CR>", { desc = "Toggle line number" })

	-- center cursor when moving (goto_definition)
	map("n", "<C-u>", "<C-u>zz")
	map("n", "<C-d>", "<C-d>zz")
	map("n", "n", "nzzzv")
	map("n", "N", "Nzzzv")

	-- [ Misc ] --
	if vim.loop.os_uname().sysname == "Darwin" then
		map(
			"n",
			"gx",
			":execute 'silent! !open ' . shellescape(expand('<cWORD>'), 1)<cr>",
			{ desc = "Open link under cursor" }
		)
	else
		map(
			"n",
			"gx",
			":execute 'silent! !xdg-open ' . shellescape(expand('<cWORD>'), 1)<cr>",
			{ desc = "Open link under cursor" }
		)
	end

	-- }}}
	-- [ Terminal] -- {{{
	map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })
	map("t", "jk", "<C-\\><C-n>", { desc = "Enter normal mode" })
	-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
	-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
	-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
	-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
	-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
	-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
	-- map("t", "JK", "<C-\\><C-n> :lua rb.close_buffer() <CR>") -- hide a terminal from within terminal mode
	map(
		"n",
		"<leader>th",
		":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>",
		{ desc = "Open terminal (Horizontal)" }
	)
	map(
		"n",
		"<leader>tv",
		":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>",
		{ desc = "Open terminal (Vertical)" }
	)
	map(
		"n",
		"<leader>tw",
		":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>",
		{ desc = "Open new terminal window" }
	)
	map("t", ":q!", "<C-\\><C-n>:q!<CR>", { desc = "Quit terminal" })
	-- }}}
end

------------ [ Plugins ] ------------
-- All plugin related mappings     --
-------------------------------------

-- TODO: Refactor into lsp subdirectory
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

return M
