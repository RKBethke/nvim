local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local M = {}

-------------- [ Commands ] ------------
function M.enable_format_on_save()
    vim.cmd([[
    augroup format_on_save
      au!
      au BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 2000)
    augroup end
  ]])
end

function M.toggle_format_on_save()
    if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
        M.enable_format_on_save()
        vim.notify("LSP: Format On Save - Enabled")
    else
        vim.cmd("au! format_on_save")
        vim.notify("LSP: Format On Save - Disabled")
    end
end

vim.cmd("command! LSPToggleFormatOnSave lua require('plugins.configs.lspconfig').toggle_format_on_save()")

-------------- [ UI ] ------------
local function lspSymbol(name, icon)
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

lspSymbol("Error", "")
lspSymbol("Info", "")
lspSymbol("Hint", "")
lspSymbol("Warn", "")

vim.diagnostic.config({
    severity_sort = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    -- virtual_text = {
    --    prefix = "",
    -- },
})

local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
    max_width = max_width,
    max_height = max_height,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
    max_width = max_width,
    max_height = max_height,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = true,
    signs = true,
})

-- suppress error messages from lang servers
vim.notify = function(msg, log_level)
    if msg:match("exit code") then
        return
    end
    if log_level == vim.log.levels.ERROR then
        vim.api.nvim_err_writeln(msg)
    else
        vim.api.nvim_echo({ { msg } }, true, {})
    end
end

-- credits to @Malace : https://www.reddit.com/r/neovim/comments/ql4iuj/rename_hover_including_window_title_and/
   -- This is modified version of the above snippet
   vim.lsp.buf.rename = {
      float = function()
         local currName = vim.fn.expand "<cword>" .. " "

         local win = require("plenary.popup").create(currName, {
            title = "Rename",
            style = "minimal",
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            relative = "cursor",
            borderhighlight = "RenamerBorder",
            titlehighlight = "RenamerTitle",
            focusable = true,
            width = 25,
            height = 1,
            line = "cursor+2",
            col = "cursor-1",
         })

         local map_opts = { noremap = true, silent = true }

         vim.cmd "normal w"
         vim.cmd "startinsert"

         vim.api.nvim_buf_set_keymap(0, "i", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)
         vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "<cmd>stopinsert | q!<CR>", map_opts)

         vim.api.nvim_buf_set_keymap(
            0,
            "i",
            "<CR>",
            "<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
            map_opts
         )

         vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<CR>",
            "<cmd>stopinsert | lua vim.lsp.buf.rename.apply(" .. currName .. "," .. win .. ")<CR>",
            map_opts
         )
      end,

      apply = function(curr, win)
         local newName = vim.trim(vim.fn.getline ".")
         vim.api.nvim_win_close(win, true)

         if #newName > 0 and newName ~= curr then
            local params = vim.lsp.util.make_position_params()
            params.newName = newName

            vim.lsp.buf_request(0, "textDocument/rename", params)
         end
      end,
   }

local function on_attach(_, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    require("core.mappings").lspconfig()
    -- Toggle auto format by default
    -- M.toggle_format_on_save()
end

----------------- [ Setup ] -----------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

-------------- [ Default Servers ] ------------
---- Servers with default config
local servers = {
    "rust_analyzer",
    "clangd",
}

-- Setup servers with defaults
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {},
    })
end

------------- [ Lua Lsp ] ------------
lspconfig.sumneko_lua.setup({
    on_attach = function(client, _)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        require("core.mappings").lspconfig()
    end,
    capabilities = capabilities,
    flags = {},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim", "use" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    vim.api.nvim_get_runtime_file("", true),
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

------------- [ Clangd Setup ] ------------
--[[
--require("clangd_extensions").setup({
    server = {
        -- options to pass to nvim-lspconfig
        -- i.e. the arguments to require("lspconfig").clangd.setup({})
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {},
    },
    extensions = {
        -- defaults:
        -- Automatically set inlay hints (type hints)
        autoSetHints = true,
        -- Whether to show hover actions inside the hover window
        -- This overrides the default hover handler
        hover_with_actions = true,
        -- These apply to the default ClangdSetInlayHints command
        inlay_hints = {
            -- Only show inlay hints for the current line
            only_current_line = true,
            -- Event which triggers a refersh of the inlay hints.
            -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
            -- not that this may cause  higher CPU usage.
            -- This option is only respected when only_current_line and
            -- autoSetHints both are true.
            only_current_line_autocmd = "CursorHold",
            -- whether to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
            -- whether to show variable name before type hints with the inlay hints or not
            show_variable_name = false,
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment",
        },
        ast = {
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },

            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },

            highlights = {
                detail = "Comment",
            },
        },
    },
})
--]]

return M
