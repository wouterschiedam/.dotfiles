return {
  {
    dir = "~/.dotfiles/nvim/lua/plugin/vimgrep_replace", -- Path to the local plugin
    config = function()
      require("plugin.vimgrep_replace").setup({
        options = {
          excluded_dir = {'node_modules', '.git', 'vendor'},
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
            win = {
              leftwin = {
                guifg = "#FFD700",
                gui = "#FFD700"
              },
              rightwin = {
                guifg = "#0077FF",
                gui = "#0077FF"
              },
              global = {
                guifg = "#FFBC2D",
                gui = "#FFBC2D"
              },
            }
          },
        }
      })
    end,
  },
}

