local map = require("util").map
local M = {}

------------ [ Defaults ] ------------
--       Called during init         --
--------------------------------------
M.defaults = function()
	-- [ General ] -- {{{
	-- Easy quit
	map("n", "<leader>qa", "<cmd>qall<CR>", { desc = "Quit all" })

	-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
	-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
	-- Empty mode is same as using :map
	-- Also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour.
	map({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
	map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

	-- Use ESC to turn off search highlighting.
	map("n", "<Esc>", ":noh <CR>")

	-- Copy entire file.
	map("n", "<C-c>", ":%y+ <CR>")

	-- Do not copy the replaced text after pasting in visual mode.
	-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
	map("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

	-- Format pasted text automatically.
	map("n", "p", "p=`]", { silent = true })

	-- Do not yank text on delete ( dd )
	-- map({ "n", "v" }, "d", '"_d')

	-- Reselect after indent
	map("v", "<", "<gv")
	map("v", ">", ">gv")

	-- Print current date
	map("n", "<leader>cd", "\"=strftime('%Y-%m-%d')<cr>P", { desc = "Paste current date" })
	map(
		"n",
		"<leader>cD",
		"\"=strftime('%a %Y-%m-%d %H:%M:%S%z')<cr>P",
		{ desc = "Paste current date (verbose)" }
	)

	-- Smart dd, only yank the line if it's not empty.
	vim.keymap.set("v", "<C-r>", function()
		local function get_visual()
			local _, ls, cs = unpack(vim.fn.getpos("v"))
			local _, le, ce = unpack(vim.fn.getpos("."))
			return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
		end
		local pattern = table.concat(get_visual())
		-- Escape regex and line endings.
		pattern = vim.fn.substitute(vim.fn.escape(pattern, "^$.*\\/~[]"), "\n", "\\n", "g")
		-- Send substitute command to vim command line.
		vim.api.nvim_input("<Esc>:%s/" .. pattern .. "//g<Left><Left>")
	end)

	map("n", "dd", function()
		return vim.fn.getline(".") == "" and '"_dd' or "dd"
	end, { expr = true })

	-- Resize window using <ctrl> + arrow keys.
	map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
	map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
	map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
	map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

	-- keywordprg
	map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

	-- Quickfix and Location lists
	map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
	map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

	map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
	map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

	-- }}}
	-- [ Navigation ] -- {{{
	-- Readline mappings (à la vim-rsi)
	map({ "n", "v" }, "<C-A>", "^", { desc = "Go to beginning of line" })
	map("c", "<C-A>", "<Home>", { desc = "Go to beginning of line" })
	map("i", "<C-A>", "<C-O>^", { desc = "Go to beginning of line" })
	map({ "i", "n", "c", "v" }, "<C-E>", "<End>", { desc = "Go to end of line" })
	map({ "i", "c" }, "<C-B>", "<Left>")
	map({ "i", "c" }, "<C-F>", "<Right>")

	-- TODO: Translate to lua
	-- inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
	-- inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
	-- cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
	-- inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
	-- inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
	-- cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

	-- Map meta
	map("i", "<M-b>", "<S-Left>")
	map({ "n", "v", "o" }, "<M-f>", "<S-Right>")
	map({ "n", "v", "o" }, "<M-d>", "<C-O>dw")
	map("c", "<M-d>", "<S-Right><C-W>")
	map({ "n", "v", "o" }, "<M-n>", "<Down>")
	map({ "n", "v", "o" }, "<M-p>", "<Up>")
	map({ "n", "v", "o" }, "<M-BS>", "<C-W>")
	map({ "n", "v", "o" }, "<M-C-h>", "<C-W>")

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

	-- Show highlight groups under cursor
	map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

	-- }}}
	-- [ Terminal] -- {{{
	map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })
	map("t", "jk", "<C-\\><C-n>", { desc = "Enter normal mode" })
	map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
	map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
	map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
	map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
	map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
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

return M
