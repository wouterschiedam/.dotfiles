require('kanagawa').setup({
  ...,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none"
        }
      }
    }
  },
  transparent = true,
  terminalColors = true,
  theme = "wave",
  dimInactive = true,
  overrides = function(colors)
    local theme = colors.theme
    return {
      LineNr = { bg = 'none' },

      -- telescope
      TelescopeTitle = { fg = theme.ui.special, bold = true },
      TelescopePromptNormal = { bg = theme.ui.bg },
      TelescopePromptBorder = { fg = theme.ui.bg_p2, bg = theme.ui.bg },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg },
      TelescopeResultsBorder = { fg = theme.ui.bg_p2, bg = theme.ui.bg },
      TelescopePreviewNormal = { bg = theme.ui.bg },
      TelescopePreviewBorder = { fg = theme.ui.bg_p2, bg = theme.ui.bg },

      -- popup menus
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },  -- add `blend = vim.o.pumblend` to enable transparency
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },

      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

      MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

      -- Custom additions
      Conditional = { fg = "#E6C384", bold = true, italic = false },  -- Customize `if` statements
      Type = { fg = "#DCA561",  italic = false },                     -- Customize classes
      Structure = { fg = "#7e9cd8", italic = false },                 -- Additional customization for structures
      Class = { fg = "#658594", italic = false },                     -- Customize class names

      -- Add overrides for other common italic groups
      Comment = { italic = false },
      Keyword = { italic = false },
      Function = { italic = false },
      BuiltinFunction = { fg = "#FFA066", italic = false },
      String = { fg = "#98BB6C", italic = false },
      Identifier = { fg = theme.ui.shade0, italic = false },
      Special = { fg = theme.ui.special, italic = false },
    }
  end,
})

vim.cmd.colorscheme('kanagawa')

-- Set line numbers
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='white' })
vim.api.nvim_set_hl(0, 'LineNr', { fg='white' })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='white' })
