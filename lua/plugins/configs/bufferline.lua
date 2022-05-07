local colors = require("colors." .. vim.g.theme).colors

local present, bufferline = pcall(require, "bufferline")
if not present then
    return
end

bufferline.setup({
    options = {
        offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
        buffer_close_icon = "",
        modified_icon = "",
        close_icon = "",
        show_close_icon = true,
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 16,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        view = "multiwindow",
        show_buffer_close_icons = true,
        separator_style = "thin",
        always_show_bufferline = true,
        diagnostics = false,
	themable = true,
        custom_filter = function(buf_number)
            -- Func to filter out our managed/persistent split terms
            local present_type, type = pcall(function()
                return vim.api.nvim_buf_get_var(buf_number, "term_type")
            end)

            if present_type then
                if type == "vert" then
                    return false
                elseif type == "hori" then
                    return false
                end
                return true
            end

            return true
        end,
    },

    highlights = {
        background = {
            guifg = colors.fgfaded,
            guibg = colors.lightbg,
        },

        -- buffers
        buffer_selected = {
            guifg = colors.fg,
            guibg = colors.bg,
            gui = "bold",
        },

        buffer_visible = {
            guifg = colors.fgfaded,
            guibg = colors.lightbg,
        },

        -- for diagnostics = "nvim_lsp"
        error = {
            guifg = colors.fgfaded,
            guibg = colors.lightbg,
        },
        error_diagnostic = {
            guifg = colors.fgfaded,
            guibg = colors.lightbg,
        },

        -- close buttons
        close_button = {
            guifg = colors.fgfaded,
            guibg = colors.lightbg,
        },
        close_button_visible = {
            guifg = colors.fgfaded,
            guibg = colors.lightbg,
        },
        close_button_selected = {
            guifg = colors.red,
            guibg = colors.bg,
        },
        fill = {
            guifg = colors.grey_fg,
            guibg = colors.lightbg,
        },
        indicator_selected = {
            guifg = colors.bg,
            guibg = colors.bg,
        },

        -- modified
        modified = {
            guifg = colors.red,
            guibg = colors.lightbg,
        },
        modified_visible = {
            guifg = colors.red,
            guibg = colors.lightbg,
        },
        modified_selected = {
            guifg = colors.green,
            guibg = colors.bg,
        },

        -- separators
        separator = {
            guifg = colors.lightbg,
            guibg = colors.lightbg,
        },
        separator_visible = {
            guifg = colors.lightbg,
            guibg = colors.lightbg,
        },
        separator_selected = {
            guifg = colors.lightbg,
            guibg = colors.lightbg,
        },

        -- tabs
        tab = {
            guifg = colors.light_grey,
            guibg = colors.bg,
        },
        tab_selected = {
            guifg = colors.lightbg,
            guibg = colors.blue,
        },
        tab_close = {
            guifg = colors.red,
            guibg = colors.bg,
        },
    },
})
