local present, cmp = pcall(require, "cmp")
if not present then
    return
end

local luasnip_present, luasnip = pcall(require, "luasnip")
if not luasnip_present then
    return
end

vim.opt.completeopt = "menuone,noselect"

local function border(hl_name)
    return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
    }
end

local cmp_window = require("cmp.utils.window")

cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
    local info = self:info_()
    info.scrollable = false
    return info
end

cmp.setup({
    window = {
        completion = {
            border = border("CmpBorder"),
        },
        documentation = {
            border = border("CmpDocBorder"),
        },
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    formatting = {
        format = function(_, vim_item)
            local icons = require("plugins.configs.lspkind_icons")
            vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)

            return vim_item
        end,
    },
    mapping = {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            select = true,
        }),
        ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item(cmp.SelectBehavior.Select)
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(cmp.SelectBehavior.Select)
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    },
    sources = {
        { name = "luasnip", max_item_count = 5 },
        { name = "nvim_lsp", max_item_count = 5 },
        {
            name = "buffer",
            max_item_count = 5,
            option = { -- Use all open buffers
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end,
            },
        },
        { name = "nvim_lua" },
        { name = "path" },
    },
    -- preselect = cmp.PreselectMode.None,
})
