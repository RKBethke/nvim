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

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

-- (From LazyVim)
-- Returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.uv.cwd()
		---@type string?
		root = vim.fs.find({ ".git", "lua" }, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.uv.cwd()
	end
	---@cast root string
	return root
end

-- (From LazyVim)
-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts

		opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
		if builtin == "files" then
			if vim.uv.fs_stat((opts.cwd or vim.uv.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		end

		if opts.cwd and opts.cwd ~= vim.uv.cwd() then
			opts.attach_mappings = function(_, _)
				vim.keymap.set("i", "<a-c>", function()
					local action_state = require("telescope.actions.state")
					local line = action_state.get_current_line()
					M.telescope(
						params.builtin,
						vim.tbl_deep_extend(
							"force",
							{},
							params.opts or {},
							{ cwd = false, default_text = line }
						)
					)()
				end)
				return true
			end
		end

		require("telescope.builtin")[builtin](opts)
	end
end

function M.is_dark_mode()
	if vim.loop.os_uname().sysname == "Darwin" then
		if vim.fn.executable('defaults') ~= 0 then
			local style = vim.fn.system({"defaults", "read", "-g", "AppleInterfaceStyle"})
			return style:find("Dark")
		end
	end
	return false
end

return M
