-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- use({
  --     "catppuccin/nvim", as = "catppuccin",
  --     config = function()
  --         vim.cmd('colorscheme catppuccin')
  --         require("catppuccin").setup {
  --             color_overrides = {
  --             }
  --         }
  --     end
  -- })

  -- use 'rose-pine/neovim';
  use 'AlexvZyl/nordic.nvim';

  use ('vimwiki/vimwiki')

  -- Codeium
  use {
    "Exafunction/codeium.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({
        })
    end
  }
  use "onsails/lspkind.nvim"


  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.3',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use { 'nvim-treesitter/nvim-treesitter',
  run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
  end,}

  use("windwp/nvim-ts-autotag");
  use("mbbill/undotree")
  use("tpope/vim-fugitive")
  -- lsp for the win
  use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      requires = {
          -- LSP Support
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
      }
  }

  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = false,
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
  })

  use {
    'L3MON4D3/LuaSnip',
    tag = "v2.3.0",
    run = "make install_jsregexp",
  }

  use("nvim-treesitter/playground")
  -- quick files
  use("theprimeagen/harpoon")
  use("theprimeagen/refactoring.nvim")
  use("nvim-treesitter/nvim-treesitter-context");

  -- Easy life for html
  use 'mhartington/formatter.nvim'
  use("mattn/emmet-vim");
  -- html/css/bootstrap suggestions
  use "sharkdp/fd"
  use "nvim-lua/plenary.nvim"

  -- comments ARE usefull
  use "terrortylor/nvim-comment"

end)
