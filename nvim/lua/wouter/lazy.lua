-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local plugins = {
    {"savq/melange-nvim"},

    -- Codeium
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({})
        end,
    },

    "onsails/lspkind.nvim",

    -- Telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        dependencies = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require("telescope").setup({})
        end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
    },

    -- Autotag
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Undo tree
    "mbbill/undotree",

    -- Fugitive
    "tpope/vim-fugitive",

    -- LSP Setup
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-cmdline'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        },
    },

    -- Trouble
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end,
    },

    -- Blame
    "FabijanZulj/blame.nvim",

    -- LuaSnip
    {
        'L3MON4D3/LuaSnip',
        tag = "v2.3.0",
        build = "make install_jsregexp",
        config = function()
            local luasnip = require("luasnip")
            luasnip.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- Null-ls
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("null-ls").setup({})
        end,
    },

    -- Quick files
    "theprimeagen/harpoon",
    "theprimeagen/refactoring.nvim",
    "nvim-treesitter/nvim-treesitter-context",


    -- Neodev
    {
        "folke/neodev.nvim",
    },

    -- Lualine
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = "",
                    component_separators = "",
                },
            })
        end,
    },

    -- Notebook
    "hkupty/iron.nvim",
}

require('lazy').setup(plugins, {})
