local M = {
	"feline-nvim/feline.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	event = "VeryLazy",
}

function M.config()
	local function file_info()
		local parent = vim.fn.expand("%:p:h:t")
		local filename = vim.fn.expand("%:t")
		local display_path = string.format("%s/%s", parent, filename)
		local extension = vim.fn.expand("%:e")
		local icon = require("nvim-web-devicons").get_icon(filename, extension)
		if icon == nil then
			icon = ""
		end
		return " " .. icon .. " " .. display_path
	end

	local function git()
		local git_status = vim.b.gitsigns_status_dict
		if git_status == nil then
			return ""
		end

		local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
		local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
		local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
		local branch_name = "   " .. git_status.head .. " "

		return branch_name .. added .. changed .. removed
	end

	local function diagnostics()
		local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		local num_hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		local num_info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

		local errors = (num_errors and num_errors > 0) and ("%#DiagnosticSignError#" .. " " .. num_errors .. " ")
			or ""
		local warnings = (num_warnings and num_warnings > 0)
				and ("%#DiagnosticSignWarn#" .. "  " .. num_warnings .. " ")
			or ""
		local hints = (num_hints and num_hints > 0) and ("%#Yellow#" .. "ﯧ " .. num_hints .. " ") or ""
		-- local hints = ""
		local info = (num_info and num_info > 0) and ("%#DiagnosticSignInfo#" .. " " .. num_info .. " ") or ""

		return errors .. warnings .. hints .. info .. "%#StatusLine#"
	end

	local function lsp_progress()
		local width = vim.api.nvim_win_get_width(0)
		local Lsp = vim.lsp.util.get_progress_messages()[1]
		if width <= 80 or not Lsp then
			return ""
		end

		local msg = Lsp.message or ""
		local percentage = Lsp.percentage or 0
		local title = Lsp.title or ""
		local spinners = { "", "", "" }
		local success_icon = { "", "", "" }

		local ms = vim.loop.hrtime() / 1000000
		local frame = math.floor(ms / 120) % #spinners

		if percentage >= 70 then
			return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
		end

		return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
	end

	local function lsp_icon()
		if next(vim.lsp.buf_get_clients()) ~= nil then
			local lsp_name = vim.lsp.get_active_clients()[1].name

			return "  " .. lsp_name .. " "
		else
			return " "
		end
	end

	local function current_pos()
		local current_line = vim.fn.line(".")
		local current_col = vim.fn.col(".")
		local total_line = vim.fn.line("$")

		if current_line == 1 then
			return "  " .. current_line .. ":" .. current_col .. "|" .. "Top "
		elseif current_line == vim.fn.line("$") then
			return "  " .. current_line .. ":" .. current_col .. "|" .. "Bot "
		end
		local result, _ = math.modf((current_line / total_line) * 100)

		local resultString = tostring(result)
		if result < 10 then
			resultString = " " .. resultString
		end

		return "  " .. current_line .. ":" .. current_col .. "|" .. resultString .. "%% "
	end

	local spacer = "    "

	Statusline = {}
	Statusline.active = function()
		return table.concat({
			"%#StatusLine#",
			file_info(),
			"%=",
			git(),
			lsp_progress(),
			"%=%<%#StatusLineExtra#",
			diagnostics(),
			lsp_icon(),
			current_pos(),
		})
	end

	vim.opt.statusline = "%!v:lua.Statusline.active()"
end

return M
