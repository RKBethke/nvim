local M = {}

M.run = function()
	return table.concat({
		"%#StatusLine#",
		M.file_info(),
		M.extra_mode_status(),
		"%=",
		M.git(),
		M.lsp_progress(),
		"%=%<%#StatusLineExtra#",
		M.diagnostics(),
		M.lsp_icon(),
		M.current_pos(),
	})
end

function M.file_info()
	local parent = vim.fn.expand("%:p:h:t")
	local filename = vim.fn.expand("%:t")
	local display_path = string.format("%s/%s", parent, filename)
	local icon = require("mini.icons").get("file", filename) or ""
	return " " .. icon .. " " .. display_path
end

function M.git()
	local git_status = vim.b.gitsigns_status_dict
	if git_status == nil then
		return ""
	end

	local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added)
		or ""
	local changed = (git_status.changed and git_status.changed ~= 0)
			and ("  " .. git_status.changed)
		or ""
	local removed = (git_status.removed and git_status.removed ~= 0)
			and ("  " .. git_status.removed)
		or ""
	local branch_name = "   " .. git_status.head .. " "

	return branch_name .. added .. changed .. removed
end

function M.diagnostics()
	local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local num_hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	local num_info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

	local errors = (num_errors and num_errors > 0)
			and ("%#DiagnosticSignError#" .. " " .. num_errors .. " ")
		or ""
	local warnings = (num_warnings and num_warnings > 0)
			and ("%#DiagnosticSignWarn#" .. "  " .. num_warnings .. " ")
		or ""
	local hints = (num_hints and num_hints > 0) and ("%#Yellow#" .. " " .. num_hints .. " ")
		or ""
	-- local hints = ""
	local info = (num_info and num_info > 0)
			and ("%#DiagnosticSignInfo#" .. " " .. num_info .. " ")
		or ""

	return errors .. warnings .. hints .. info .. "%#StatusLine#"
end

function M.lsp_progress()
	local width = vim.api.nvim_win_get_width(0)
	local status = vim.lsp.status()[1]
	if width <= 80 or not status then
		return ""
	end

	local msg = status.message or ""
	local percentage = status.percentage or 0
	local title = status.title or ""
	local spinners = { "", "", "" }
	local success_icon = { "", "", "" }

	local ms = vim.uv.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners

	if percentage >= 70 then
		return string.format(
			" %%<%s %s %s (%s%%%%) ",
			success_icon[frame + 1],
			title,
			msg,
			percentage
		)
	end

	return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
end

function M.lsp_icon()
	if next(vim.lsp.get_clients()) == nil then
		return " "
	end
	local lsp_name = vim.lsp.get_clients()[1].name
	return "  " .. lsp_name .. " "
end

function M.current_pos()
	local current_line = string.format("%3d", vim.fn.line("."))
	local current_col = string.format("%3d", vim.fn.col("."))
	local total_line = vim.fn.line("$")

	local result, _ = string.format("%2d%% ", math.modf((current_line / total_line) * 100))
	if current_line == 1 then
		result = "Top "
	elseif current_line == vim.fn.line("$") then
		result = "Bot "
	end

	return "  " .. current_line .. ":" .. current_col .. "|" .. result
end

function M.extra_mode_status()
	-- Recording macros
	local reg_recording = vim.fn.reg_recording()
	if reg_recording ~= "" then
		return "  @" .. reg_recording
	end
	-- Executing macros
	local reg_executing = vim.fn.reg_executing()
	if reg_executing ~= "" then
		return "  @" .. reg_executing
	end
	-- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
	local mode = vim.api.nvim_get_mode().mode
	if mode == "ix" then
		return " ^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)"
	end
	return ""
end

return M
