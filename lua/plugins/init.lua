local present, packer = pcall(require, "plugins.packerInit")

if not present then
    return false
end

local use = packer.use

return packer.startup(function()
    -- this is arranged on the basis of when a plugin starts
    ---------------- [ Core ]----------------
    use({
	    "nvim-lua/plenary.nvim",
	    module = "plenary",
	})
	
    use("lewis6991/impatient.nvim")

    use({
        "wbthomason/packer.nvim",
        event = "VimEnter",
    })

    ---------------- [ Colorscheme ] ----------------
    use({
        "sainnhe/gruvbox-material",
    })
    -------------------------------------------------

    use({
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("plugins.configs.icons")
        end,
    })

    use({
        "feline-nvim/feline.nvim",
        after = "nvim-web-devicons",
        config = function()
            require("plugins.configs.statusline")
        end,
    })

    use({
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        after = "nvim-web-devicons",
        config = function()
            require("plugins.configs.bufferline")
        end,
        setup = function()
            require("core.mappings").bufferline()
        end,
    })

    use({
        "lukas-reineke/indent-blankline.nvim",
        event = "BufRead",
        config = function()
            require("plugins.configs.others").blankline()
        end,
    })

    use({
        "norcalli/nvim-colorizer.lua",
        event = "BufRead",
        config = function()
            require("plugins.configs.others").colorizer()
        end,
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        config = function()
            require("plugins.configs.treesitter")
        end,
        run = ":TSUpdate",
    })

    ---------------- [ Git ] ----------------
    use({
        "lewis6991/gitsigns.nvim",
        opt = true,
        config = function()
            require("plugins.configs.others").gitsigns()
        end,
        setup = function()
            rb.packer_lazy_load("gitsigns.nvim")
        end,
    })

    ---------------- [ Lsp ] ----------------
    use({
        "williamboman/nvim-lsp-installer",
        opt = true,
        setup = function()
            rb.packer_lazy_load("nvim-lsp-installer")
            -- reload the current file so lsp actually starts for it
            vim.defer_fn(function()
                vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
            end, 0)
        end,
    })

    use({
        "neovim/nvim-lspconfig",
        after = "nvim-lsp-installer",
        module = "lspconfig",
        config = function()
            require("plugins.configs.lsp_installer")
            require("plugins.configs.lspconfig")
        end,
    })

    use({
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("plugins.configs.others").signature()
        end,
    })

    -- Used for formatter and linter integration
    use({
        "jose-elias-alvarez/null-ls.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("plugins.configs._null-ls").setup()
        end,
    })

    use({
        "andymass/vim-matchup",
        opt = true,
        setup = function()
            rb.packer_lazy_load("vim-matchup") -- Load plugin after entering vim ui
        end,
    })

    ---------------- [ Luasnips + Cmp ] ----------------
    use({
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
    })

    use({
        "hrsh7th/nvim-cmp",
        after = "friendly-snippets",
        config = function()
            require("plugins.configs.cmp")
        end,
    })

    use({
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        after = "nvim-cmp",
        config = function()
            require("plugins.configs.others").luasnip()
        end,
    })

    use({
        "saadparwaiz1/cmp_luasnip",
        after = "LuaSnip",
    })

    use({
        "hrsh7th/cmp-nvim-lua",
        after = "cmp_luasnip",
    })

    use({
        "hrsh7th/cmp-nvim-lsp",
        after = "cmp-nvim-lua",
    })

    use({
        "hrsh7th/cmp-buffer",
        after = "cmp-nvim-lsp",
    })

    use({
        "hrsh7th/cmp-path",
        after = "cmp-buffer",
    })

    ---------------- [ Misc Plugins ] ----------------
    use({
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("plugins.configs.others").better_escape()
        end,
    })

    use({
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            require("plugins.configs.others").autopairs()
        end,
    })

    use({
        "numToStr/Comment.nvim",
        module = "Comment",
        keys = { "gc", "gb" },
        setup = function()
            require("core.mappings").comment()
        end,

        config = function()
            require("plugins.configs.others").comment()
        end,
    })

    -- Helpful plugin dealing with surrounding symbols
    use({
        "machakann/vim-sandwich",
        event = "InsertEnter",
        config = function()
            require("plugins.configs.vim-sandwich")
        end,
    })

    use({
        "ggandor/lightspeed.nvim",
        event = "BufRead",
    })

    ---------------- [ File managing , Picker etc. ] ----------------
    use({
        "kyazdani42/nvim-tree.lua",
        after = "nvim-web-devicons",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            require("plugins.configs.nvimtree")
        end,
        setup = function()
            require("core.mappings").nvimtree()
        end,
    })

    use({
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        setup = function()
            require("core.mappings").telescope()
        end,
        config = function()
            require("plugins.configs.telescope")
        end,
    })
end)
