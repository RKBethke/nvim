local set = vim.keymap.set
local M = {}

------------ [ Defaults ] ------------
--       Called during init         --
--------------------------------------
M.defaults = function()
	-- [ General ] -- {{{
	-- Easy quit
	set("n", "<leader>qa", "<cmd>qall<CR>", { desc = "Quit all" })

	-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
	-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
	-- Empty mode is same as using :map
	-- Also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour.
	set({ "n", "x", "o" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	set({ "n", "x", "o" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
	set("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
	set("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

	-- Use ESC to turn off search highlighting.
	set("n", "<Esc>", ":noh <CR>")

	-- Close current buffer.
	set("n", "<C-c>", ":bd<CR>")

	-- Do not copy the replaced text after pasting in visual mode.
	-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
	set("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { silent = true })

	-- Format pasted text automatically.
	set("n", "p", "p=`]", { silent = true })

	-- Reselect after indent
	set("v", "<", "<gv")
	set("v", ">", ">gv")

	-- Print current date
	set("n", "<leader>cd", "\"=strftime('%Y-%m-%d')<cr>P", { desc = "Paste current date" })
	set(
		"n",
		"<leader>cD",
		"\"=strftime('%a %Y-%m-%d %H:%M:%S%z')<cr>P",
		{ desc = "Paste current date (verbose)" }
	)

	-- Smart dd: Only yank the line if it's not empty.
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

	set("n", "dd", function()
		return vim.fn.getline(".") == "" and '"_dd' or "dd"
	end, { expr = true })

	-- keywordprg
	set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

	-- Quickfix and Location lists
	set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
	set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

	set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
	set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
	set("n", "[l", vim.cmd.cprev, { desc = "Previous loclist" })
	set("n", "]l", vim.cmd.cnext, { desc = "Next loclist" })

	-- }}}
	-- [ Navigation ] -- {{{
	-- Readline mappings (à la vim-rsi)
	set({ "n", "v" }, "<C-A>", "^", { desc = "Go to beginning of line" })
	set("c", "<C-A>", "<Home>", { desc = "Go to beginning of line" })
	set("i", "<C-A>", "<C-O>^", { desc = "Go to beginning of line" })
	set({ "i", "n", "c", "v" }, "<C-E>", "<End>", { desc = "Go to end of line" })
	set({ "i", "c" }, "<C-B>", "<Left>")
	set({ "i", "c" }, "<C-F>", "<Right>")

	-- TODO: Translate to lua
	-- inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
	-- inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
	-- cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
	-- inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
	-- inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
	-- cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

	-- Map meta
	set("i", "<M-b>", "<S-Left>")
	set({ "n", "v", "o" }, "<M-f>", "<S-Right>")
	set({ "n", "v", "o" }, "<M-d>", "<C-O>dw")
	set("c", "<M-d>", "<S-Right><C-W>")
	set({ "n", "v", "o" }, "<M-n>", "<Down>")
	set({ "n", "v", "o" }, "<M-p>", "<Up>")
	set({ "n", "v", "o" }, "<M-BS>", "<C-W>")
	set({ "n", "v", "o" }, "<M-C-h>", "<C-W>")

	-- [ Between windows ] --
	set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
	set("n", "<C-l>", "<C-w>l", { desc = "Go to lower window" })
	set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
	set("n", "<C-j>", "<C-w>j", { desc = "Go to right window" })

	-- Control the split size
	set("n", "<M-,>", "<c-w>5<")
	set("n", "<M-.>", "<c-w>5>")
	set("n", "<M->>", "<C-W>5+")
	set("n", "<M-<>", "<C-W>5-")

	set("n", "<M-j>", function()
		if vim.opt.diff:get() then
			vim.cmd([[normal! ]c]])
		else
			vim.cmd([[m .+1<CR>==]])
		end
	end)

	set("n", "<M-k>", function()
		if vim.opt.diff:get() then
			vim.cmd([[normal! [c]])
		else
			vim.cmd([[m .-2<CR>==]])
		end
	end)

	set("n", "<S-t>", ":enew <CR>", { desc = "New buffer" })
	set("n", "<C-t>b", ":tabnew <CR>", { desc = "New tab" })
	set("n", "H", ":bprev<CR>", { desc = "Switch to previous buffer" })
	set("n", "L", ":bnext<CR>", { desc = "Switch to next buffer" })

	-- [ UI ] --
	set("n", "<leader>un", ":set nu! <CR>", { desc = "Toggle line number" })

	-- center cursor when moving (goto_definition)
	set("n", "<C-u>", "<C-u>zz")
	set("n", "<C-d>", "<C-d>zz")
	set("n", "n", "nzzzv")
	set("n", "N", "Nzzzv")

	-- [ Misc ] --
	if vim.loop.os_uname().sysname == "Darwin" then
		set(
			"n",
			"gx",
			":execute 'silent! !open ' . shellescape(expand('<cWORD>'), 1)<cr>",
			{ desc = "Open link under cursor" }
		)
	else
		set(
			"n",
			"gx",
			":execute 'silent! !xdg-open ' . shellescape(expand('<cWORD>'), 1)<cr>",
			{ desc = "Open link under cursor" }
		)
	end

	-- Show highlight groups under cursor
	set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

	-- }}}
	-- [ Terminal] -- {{{
	set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })
	set("t", "jk", "<C-\\><C-n>", { desc = "Enter normal mode" })
	set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
	set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
	set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
	set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
	set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
	set(
		"n",
		"<leader>th",
		":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>",
		{ desc = "Open terminal (Horizontal)" }
	)
	set(
		"n",
		"<leader>tv",
		":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>",
		{ desc = "Open terminal (Vertical)" }
	)
	set(
		"n",
		"<leader>tw",
		":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>",
		{ desc = "Open new terminal window" }
	)
	set("t", ":q!", "<C-\\><C-n>:q!<CR>", { desc = "Quit terminal" })
	-- }}}
end

return M
