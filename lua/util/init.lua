local M = {}

function M.require(mod)
	local ok, ret = M.try(require, mod)
	return ok and ret
end

function M.try(fn, ...)
	local args = { ... }

	local error_handler = function(err)
		local lines = {}
		table.insert(lines, err)
		table.insert(lines, debug.traceback("", 3))

		M.error(table.concat(lines, "\n"))
		return err
	end

	return xpcall(function()
		return fn(unpack(args))
	end, error_handler)
end

function M.display_version()
	local v = vim.version()
	if v then
		vim.notify(("Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch), vim.log.levels.INFO)
	end
end

function M.warn(msg, name)
	vim.notify(msg, vim.log.levels.WARN, { title = name or "init.lua" })
end

function M.error(msg, name)
	vim.notify(msg, vim.log.levels.ERROR, { title = name or "init.lua" })
end

function M.info(msg, name)
	vim.notify(msg, vim.log.levels.INFO, { title = name or "init.lua" })
end

function M.map(mode, keys, command, opt)
	local options = { noremap = true, silent = true }
	if opt then
		options = vim.tbl_extend("force", options, opt)
	end

	-- all valid modes allowed for mappings
	-- :h map-modes
	local valid_modes = {
		[""] = true,
		["n"] = true,
		["v"] = true,
		["s"] = true,
		["x"] = true,
		["o"] = true,
		["!"] = true,
		["i"] = true,
		["l"] = true,
		["c"] = true,
		["t"] = true,
	}

	-- helper function for M.map
	-- can gives multiple modes and keys
	local function map_wrapper(sub_mode, lhs, rhs, sub_options)
		if type(lhs) == "table" then
			for _, key in ipairs(lhs) do
				map_wrapper(sub_mode, key, rhs, sub_options)
			end
		else
			if type(sub_mode) == "table" then
				for _, m in ipairs(sub_mode) do
					map_wrapper(m, lhs, rhs, sub_options)
				end
			else
				if valid_modes[sub_mode] and lhs and rhs then
					vim.api.nvim_set_keymap(sub_mode, lhs, rhs, sub_options)
				else
					sub_mode, lhs, rhs = sub_mode or "", lhs or "", rhs or ""
					print(
						"Cannot set mapping [ mode = '"
							.. sub_mode
							.. "' | key = '"
							.. lhs
							.. "' | cmd = '"
							.. rhs
							.. "' ]"
					)
				end
			end
		end
	end

	map_wrapper(mode, keys, command, options)
end

function M.close_buffer(force)
	if vim.bo.buftype == "terminal" then
		force = force or vim.api.nvim_list_wins() < 2 and ":bd!"
		local swap = force and vim.api.nvim_list_bufs() > 1 and ":bp | bd!" .. vim.fn.bufnr()
		return vim.cmd(swap or force or "hide")
	end

	local fileExists = vim.fn.filereadable(vim.fn.expand("%p"))
	local modified = vim.api.nvim_buf_get_option(vim.fn.bufnr(), "modified")

	-- if file doesnt exist & its modified
	if fileExists == 0 and modified then
		print("no file name? add it now!")
		return
	end

	force = force or not vim.bo.buflisted or vim.bo.buftype == "nofile"
	-- if not force, change to prev buf and then close current
	local close_cmd = force and ":bd!" or ":bp | bd" .. vim.fn.bufnr()
	vim.cmd(close_cmd)
end

return M
