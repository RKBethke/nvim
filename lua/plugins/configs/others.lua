local M = {}

M.autopairs = function()
    local present1, autopairs = pcall(require, "nvim-autopairs")
    local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

    if present1 and present2 then
        autopairs.setup({ fast_wrap = {} })

        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
end

M.better_escape = function()
    require("better_escape").setup({
        mapping = "jk",
        timeout = 300,
    })
end

M.blankline = function()
    require("indent_blankline").setup({
        indentLine_enabled = 1,
        char = "▏",
        filetype_exclude = {
            "help",
            "terminal",
            "dashboard",
            "packer",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "lsp-installer",
            "",
        },
        buftype_exclude = { "terminal" },
        show_trailing_blankline_indent = false,
        show_first_indent_level = false,
    })
end

M.colorizer = function()
    local present, colorizer = pcall(require, "colorizer")
    if present then
        colorizer.setup({ "*" }, {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- "Name" codes like Blue
            RRGGBBAA = false, -- #RRGGBBAA hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

            -- Available modes: foreground, background
            mode = "background", -- Set the display mode.
        })
        vim.cmd("ColorizerReloadAllBuffers")
    end
end

M.comment = function()
    local present, nvim_comment = pcall(require, "Comment")
    if present then
        nvim_comment.setup()
    end
end

M.luasnip = function()
    local present, luasnip = pcall(require, "luasnip")
    if present then
        luasnip.config.set_config({
            history = true,
            updateevents = "TextChanged,TextChangedI",
        })

        require("luasnip/loaders/from_vscode").load({ paths = "" })
        require("luasnip/loaders/from_vscode").load()
    end
end

M.signature = function()
    local present, lspsignature = pcall(require, "lsp_signature")
    if present then
        lspsignature.setup({
            bind = true,
            doc_lines = 0,
            floating_window = true,
            fix_pos = true,
            hint_enable = true,
            hint_prefix = " ",
            hint_scheme = "String",
            hi_parameter = "Search",
            max_height = 22,
            max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
            handler_opts = {
                border = "single", -- double, single, shadow, none
            },
            zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
            padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
        })
    end
end

M.gitsigns = function()
    local present, gitsigns = pcall(require, "gitsigns")
    if present then
        gitsigns.setup({
            signs = {
                add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
                change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
                delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
                topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
                changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
            },
        })
    end
end

M.scnvim = function()
    vim.g.sccnvim_snippet_format = "luasnip"
    -- Automatically open post window on a SC error
    vim.g.scnvim_postwin_auto_toggle = 1
    
    -- For scnvim snippets
    require("luasnip").snippets.supercollider = require("scnvim/utils").get_snippets()
end

return M
