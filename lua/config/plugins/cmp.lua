local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"dmitmel/cmp-cmdline-history",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
	},
}

function M.config()
	vim.o.completeopt = "menuone,noselect,preview"

	local cmp = require("cmp")
	local menu_tags = {
		nvim_lsp = " ",
		nvim_lua = "[api]",
	}
	local kind_tags = {
		Snippet = " ",
		File = "🗎 ",
		Folder = " "
	}

	cmp.setup({
		experimental = {
			ghost_text = true,
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		formatting = {
			format = function(entry, vim_item)
				-- vim_item.kind = string.format("%s %s", M.icons[vim_item.kind], vim_item.kind)
				local kind_tag = kind_tags[vim_item.kind]
				if kind_tag then
					vim_item.kind = kind_tag
				end

				local menu_tag = menu_tags[entry.source.name]
				if menu_tag then
					vim_item.menu = menu_tag
				end

				return vim_item
			end,
		},
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
			["<Tab>"] = cmp.mapping(function(fallback)
				-- This little snippet will confirm with tab, and if no entry is selected,
				-- will confirm the first item.
				if cmp.visible() then
					local entry = cmp.get_selected_entry()
					if entry then
						cmp.confirm()
					else
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						cmp.confirm()
					end
				else
					fallback()
				end
			end, { "i", "s", "c" }),
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
	})
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline_history" },
		}, {
			{
				name = "cmdline",
				option = {
					ignore_cmds = { "Man", "!" },
				},
			},
		}),
	})
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})
end

return M
