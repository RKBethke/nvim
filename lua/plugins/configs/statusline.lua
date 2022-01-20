local colors = require("colors." .. vim.g.theme).colors
local lsp = require("feline.providers.lsp")
local lsp_severity = vim.diagnostic.severity

local icon_styles = {
    default = {
        left = "",
        right = " ",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",
    },
    arrow = {
        left = "",
        right = "",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",
    },

    block = {
        left = " ",
        right = " ",
        main_icon = "   ",
        vi_mode_icon = "  ",
        position_icon = "  ",
    },

    round = {
        left = "",
        right = "",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",
    },

    slant = {
        left = " ",
        right = " ",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",
    },
}

-- statusline style
local user_statusline_style = "default" -- default, round, slant, block, arrow
local statusline_style = icon_styles[user_statusline_style]

-- show short statusline on small screens
local shortline = true

-- Initialize the components table
local components = {
    active = {},
}

local main_icon = {
    provider = statusline_style.main_icon,

    hl = {
        fg = colors.bg_statusline,
        bg = colors.blue,
    },

    right_sep = {
        str = statusline_style.right,
        hl = {
            fg = colors.blue,
            bg = colors.lightbg,
        },
    },
}

local file_name = {
    provider = function()
        local filename = vim.fn.expand("%:t")
        local extension = vim.fn.expand("%:e")
        local icon = require("nvim-web-devicons").get_icon(filename, extension)
        if icon == nil then
            icon = " "
            return icon
        end
        return " " .. icon .. " " .. filename .. " "
    end,
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
    end,
    hl = {
        fg = colors.fg,
        bg = colors.lightbg,
    },

    right_sep = { str = statusline_style.right, hl = { fg = colors.lightbg, bg = colors.bg_statusline } },
}

local dir_name = {
    provider = function()
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return "  " .. dir_name .. " "
    end,

    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
    end,

    hl = {
        fg = colors.fgfaded,
        bg = colors.lightbg,
    },
    right_sep = {
        str = statusline_style.right,
        hi = {
            fg = colors.lightbg,
            bg = colors.bg_statusline,
        },
    },
}

local diff = {
    add = {
        provider = "git_diff_added",
        hl = {
            fg = colors.fgfaded,
            bg = colors.bg_statusline,
        },
        icon = " ",
    },

    change = {
        provider = "git_diff_changed",
        hl = {
            fg = colors.fgfaded,
            bg = colors.bg_statusline,
        },
        icon = "   ",
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

        hl = { fg = colors.red },
        icon = "  ",
    },

    warning = {
        provider = "diagnostic_warnings",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.WARN)
        end,
        hl = { fg = colors.yellow },
        icon = "  ",
    },

    hint = {
        provider = "diagnostic_hints",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.HINT)
        end,
        hl = { fg = colors.light_grey },
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
    hl = { fg = colors.green },
}

local lsp_icon = {
    provider = function()
        if next(vim.lsp.buf_get_clients()) ~= nil then
            return "  LSP"
        else
            return ""
        end
    end,
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
    end,
    hl = { fg = colors.grey, bg = colors.bg_statusline },
}

local mode_colors = {
    ["n"] = { "NORMAL", colors.red },
    ["no"] = { "N-PENDING", colors.red },
    ["i"] = { "INSERT", colors.magenta },
    ["ic"] = { "INSERT", colors.magenta },
    ["t"] = { "TERMINAL", colors.green },
    ["v"] = { "VISUAL", colors.cyan },
    ["V"] = { "V-LINE", colors.cyan },
    [""] = { "V-BLOCK", colors.cyan },
    ["R"] = { "REPLACE", colors.orange },
    ["Rv"] = { "V-REPLACE", colors.orange },
    ["s"] = { "SELECT", colors.blue },
    ["S"] = { "S-LINE", colors.blue },
    [""] = { "S-BLOCK", colors.blue },
    ["c"] = { "COMMAND", colors.magenta },
    ["cv"] = { "COMMAND", colors.magenta },
    ["ce"] = { "COMMAND", colors.magenta },
    ["r"] = { "PROMPT", colors.cyan },
    ["rm"] = { "MORE", colors.cyan },
    ["r?"] = { "CONFIRM", colors.cyan },
    ["!"] = { "SHELL", colors.green },
}

local empty_space = {
    provider = " " .. statusline_style.left,
    hl = {
        fg = colors.lightbg,
        bg = colors.bg_statusline,
    },
}

-- this matches the vi mode color
local empty_spaceColored = {
    provider = statusline_style.left,
    hl = function()
        return {
            fg = mode_colors[vim.fn.mode()][2],
            bg = colors.lightbg,
        }
    end,
}

local mode_icon = {
    provider = statusline_style.vi_mode_icon,
    hl = function()
        return {
            fg = colors.bg_statusline,
            bg = mode_colors[vim.fn.mode()][2],
        }
    end,
}

local empty_space2 = {
    provider = function()
        return " " .. mode_colors[vim.fn.mode()][1] .. " "
    end,
    hl = {
        fg = mode_colors[vim.fn.mode()][2],
        bg = colors.bg,
    },
}

local separator_right = {
    provider = statusline_style.left,
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
    end,
    hl = {
        fg = colors.grey,
        bg = colors.bg,
    },
}

local separator_right2 = {
    provider = statusline_style.left,
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
    end,
    hl = {
        fg = colors.green,
        bg = colors.grey,
    },
}

local position_icon = {
    provider = statusline_style.position_icon,
    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
    end,
    hl = {
        fg = colors.dark_grey,
        bg = colors.green,
    },
}

local current_line = {
    provider = function()
        local current_line = vim.fn.line(".")
        local total_line = vim.fn.line("$")

        if current_line == 1 then
            return " Top "
        elseif current_line == vim.fn.line("$") then
            return " Bot "
        end
        local result, _ = math.modf((current_line / total_line) * 100)
        return " " .. result .. "%% "
    end,

    enabled = shortline or function(winid)
        return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
    end,

    hl = {
        fg = colors.green,
        bg = colors.bg,
    },
}

local function add_table(a, b)
    table.insert(a, b)
end

-- components are divided in 3 sections
local left = {}
local middle = {}
local right = {}

-- left
add_table(left, main_icon)
add_table(left, file_name)
add_table(left, dir_name)
add_table(left, diff.add)
add_table(left, diff.change)
add_table(left, diff.remove)
add_table(left, diagnostic.error)
add_table(left, diagnostic.warning)
add_table(left, diagnostic.hint)
add_table(left, diagnostic.info)

add_table(middle, lsp_progress)

-- right
add_table(right, lsp_icon)
add_table(right, git_branch)
add_table(right, empty_space)
add_table(right, empty_spaceColored)
add_table(right, mode_icon)
add_table(right, empty_space2)
add_table(right, separator_right)
add_table(right, separator_right2)
add_table(right, position_icon)
add_table(right, current_line)

components.active[1] = left
components.active[2] = middle
components.active[3] = right

require("feline").setup({
    theme = {
        bg = colors.bg_statusline,
        fg = colors.fg,
    },
    components = components,
})
