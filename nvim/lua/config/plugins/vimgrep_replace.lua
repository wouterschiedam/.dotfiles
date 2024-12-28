return {
  {
    dir = "~/.dotfiles/nvim/lua/plugin/vimgrep_replace", -- Path to the local plugin
    config = function()
      require("plugin.vimgrep_replace").setup({
        options = {
          keymaps = {
            global = {
              vimgrep = '<leader>vg',
              replace = '<leader>qr',
            },
            buffer = {
              toggle = "<Tab>",
              accept = 'l',
              decline = 'h',
              cancel = 'q',
              skip = 'n',
            },
          },
          highlight_group = {
            search = {
              fg = '#ffffff',
              bg = '#808080',
            },
            replace = {
              fg = '#ffffff',
              bg = '#FF0000',
            },
          },
        }
      })
    end,
  },
}

