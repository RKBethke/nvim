local cmp_present, cmp = pcall(require, "cmp")
if not cmp_present then
	return
end

local luasnip_present, luasnip = pcall(require, "luasnip")
if not luasnip_present then
	return
end

vim.opt.completeopt = "menuone,noselect,preview"

local cmp_window = require("cmp.utils.window")
cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
	local info = self:info_()
	info.scrollable = false
	return info
end

local menu_tags = {
	nvim_lsp = "[LSP]",
	nvim_lua = "[api]",
	path = "[path]",
	luasnip = "[snip]",
}

cmp.setup({
	experimental = {
		ghost_text = true,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			local icons = require("plugins.configs.lspkind_icons")
			vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
			vim_item.menu = menu_tags[entry.source.name]

			return vim_item
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			},
			{ "i", "c" }
		),
		["<C-space>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				})
			else
				cmp.complete()
			end
		end, { "i", "s" }),
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{
			name = "buffer",
			max_item_count = 5,
			keyword_length = 5,
			option = { -- Use all open buffers
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end,
			},
		},
		{ name = "path" },
	},
	-- preselect = cmp.PreselectMode.None,
})
