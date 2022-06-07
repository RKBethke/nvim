local colors = require("colors." .. vim.g.theme).colors
local lsp = require("feline.providers.lsp")
local lsp_severity = vim.diagnostic.severity

local icon_styles = {
    default = {
        left = "",
        right = " ",
        main_icon = " ",
        vi_mode_icon = " ",
        position_icon = " ",
    },
    arrow = {
        left = "",
        right = "",
        main_icon = " ",
        vi_mode_icon = "",
        position_icon = " ",
    },

    block = {
        left = " ",
        right = " ",
        main_icon = " ",
        vi_mode_icon = "",
        position_icon = "  ",
    },

    round = {
        left = "",
        right = "",
        main_icon = " ",
        vi_mode_icon = " ",
        position_icon = " ",
    },

    slant = {
        left = " ",
        right = " ",
        main_icon = " ",
        vi_mode_icon = " ",
        position_icon = " ",
    },
}

local mode_colors = {
    ["n"] = { "NORMAL", colors.green },
    ["no"] = { "N-PENDING", colors.red },
    ["i"] = { "INSERT", colors.magenta },
    ["ic"] = { "INSERT", colors.magenta },
    ["t"] = { "TERMINAL", colors.red },
    ["v"] = { "VISUAL", colors.cyan },
    ["V"] = { "V-LINE", colors.cyan },
    [""] = { "V-BLOCK", colors.cyan },
    ["R"] = { "REPLACE", colors.orange },
    ["Rv"] = { "V-REPLACE", colors.orange },
    ["s"] = { "SELECT", colors.blue },
    ["S"] = { "S-LINE", colors.blue },
    [""] = { "S-BLOCK", colors.blue },
    ["c"] = { "COMMAND", colors.red },
    ["cv"] = { "COMMAND", colors.red },
    ["ce"] = { "COMMAND", colors.red },
    ["r"] = { "PROMPT", colors.cyan },
    ["rm"] = { "MORE", colors.cyan },
    ["r?"] = { "CONFIRM", colors.cyan },
    ["!"] = { "SHELL", colors.green },
}

-- statusline style
local user_statusline_style = "default" -- default, round, slant, block, arrow
local statusline_style = icon_styles[user_statusline_style]

-- show short statusline on small screens
local shortline = true

local main_icon = {
    provider = function()
        return statusline_style.main_icon .. mode_colors[vim.fn.mode()][1] .. " "
    end,

    hl = function()
        return {
            fg = colors.bg_statusline,
            bg = mode_colors[vim.fn.mode()][2],
        }
    end,

    right_sep = {
        str = statusline_style.right,
        hl = function()
            return {
                fg = mode_colors[vim.fn.mode()][2],
                bg = colors.bg_statusline,
            }
        end,
    },
}

local dir_name = {
    provider = function()
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        local filename = vim.fn.expand("%:t")
        local extension = vim.fn.expand("%:e")
        local icon = require("nvim-web-devicons").get_icon(filename, extension)
        if icon == nil then
            icon = ""
        end
        return icon .. " " .. dir_name .. " "
    end,

    hl = {
        fg = colors.fgfaded,
        bg = colors.bg_statusline,
    },
}

local diff = {
    add = {
        provider = "git_diff_added",
        hl = {
            fg = colors.fgfaded,
            bg = colors.bg_statusline,
        },
        icon = "  ",
    },

    change = {
        provider = "git_diff_changed",
        hl = {
            fg = colors.fgfaded,
            bg = colors.bg_statusline,
        },
        icon = "  ",
    },

    remove = {
        provider = "git_diff_removed",
        hl = {
            fg = colors.fgfaded,
            bg = colors.bg_statusline,
        },
        icon = "  ",
    },
}

local git_branch = {
    provider = "git_branch",
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
    end,
    hl = {
        fg = colors.fgfaded,
        bg = colors.bg_statusline,
    },
    icon = "  ",
}

local diagnostic = {
    errors = {
        provider = "diagnostic_errors",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.ERROR)
        end,

        hl = { fg = colors.red, bg = colors.bg_statusline },
        icon = "  ",
    },

    warning = {
        provider = "diagnostic_warnings",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.WARN)
        end,
        hl = { fg = colors.yellow, bg = colors.bg_statusline },
        icon = "  ",
    },

    hint = {
        provider = "diagnostic_hints",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.HINT)
        end,
        hl = { fg = colors.light_grey, bg = colors.bg_statusline },
        icon = "  ",
    },

    info = {
        provider = "diagnostic_info",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.INFO)
        end,
        hl = { fg = colors.green },
        icon = "  ",
    },
}

local lsp_progress = {
    provider = function()
        local Lsp = vim.lsp.util.get_progress_messages()[1]

        if Lsp then
            local msg = Lsp.message or ""
            local percentage = Lsp.percentage or 0
            local title = Lsp.title or ""
            local spinners = {
                "",
                "",
                "",
            }

            local success_icon = {
                "",
                "",
                "",
            }

            local ms = vim.loop.hrtime() / 1000000
            local frame = math.floor(ms / 120) % #spinners

            if percentage >= 70 then
                return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
            end

            return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
        end

        return ""
    end,
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
    end,
    hl = { fg = colors.green, bg = colors.bg_statusline },
}

local lsp_icon = {
    provider = function()
        if next(vim.lsp.buf_get_clients()) ~= nil then
            local lsp_name = vim.lsp.get_active_clients()[1].name

            return "  " .. lsp_name .. " "
        else
            return " "
        end
    end,
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
    end,
    hl = { fg = colors.grey, bg = colors.bg_statusline },
}

local current_line = {
    provider = function()
        local current_line = vim.fn.line(".")
        local current_col = vim.fn.col(".")
        local total_line = vim.fn.line("$")

        -- if current_col < 10 then
        --     current_col = " " .. current_col
        -- end

        if current_line == 1 then
            return "  " .. current_line .. ":" .. current_col .. "|" .. "Top "
        elseif current_line == vim.fn.line("$") then
            return "  " .. current_line .. ":" .. current_col .. "|" .. "Bot "
        end
        local result, _ = math.modf((current_line / total_line) * 100)

        if result < 10 then
            result = " " .. result
        end

        return "  " .. current_line .. ":" .. current_col .. "|" .. result .. "%% "
    end,

    hl = {
        fg = colors.bg_statusline,
        bg = colors.green,
    },

    left_sep = {
        str = statusline_style.left,
        hl = {
            fg = colors.green,
            bg = colors.bg_statusline,
        },
    },
}

local function add_table(tbl, inject)
    if inject then
        table.insert(tbl, inject)
    end
end

-- components are divided in 3 sections
local left = {}
local middle = {}
local right = {}

-- left
add_table(left, main_icon)
add_table(left, dir_name)
add_table(left, git_branch)
add_table(left, diff.add)
add_table(left, diff.change)
add_table(left, diff.remove)

-- middle
add_table(middle, lsp_progress)

-- right
add_table(right, diagnostic.error)
add_table(right, diagnostic.warning)
add_table(right, diagnostic.hint)
add_table(right, diagnostic.info)
add_table(right, lsp_icon)
add_table(right, current_line)

-- Initialize the components table
local components = {
    active = {},
}

components.active[1] = left
components.active[2] = middle
components.active[3] = right

local theme = {
    bg = colors.statusline_bg,
    fg = colors.fg,
}

require("feline").setup({
    theme = theme,
    components = components,
})
