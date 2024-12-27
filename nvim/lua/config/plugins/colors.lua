return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd.colorscheme('rose-pine')

      local function KeepBackground()
        -- General background removal
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })

        -- Split and window backgrounds
        vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'none' })

        -- Floating windows and popups
        vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

        -- Telescope
        local telescope_hls = {
          'TelescopeNormal', 'TelescopeBorder',
          'TelescopePromptNormal', 'TelescopePromptBorder',
          'TelescopeResultsNormal', 'TelescopeResultsBorder',
          'TelescopePreviewNormal', 'TelescopePreviewBorder',
        }
        for _, hl in ipairs(telescope_hls) do
          vim.api.nvim_set_hl(0, hl, { bg = 'none' })
        end

        -- Popup menu
        vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'PmenuSel', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = 'none' })

        -- Diff and Terminal
        vim.api.nvim_set_hl(0, 'DiffAdd', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'DiffChange', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'DiffDelete', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'Terminal', { bg = 'none' })

        -- LSP highlights
        local lsp_hls = {
          'LspSignatureActiveParameter', 'LspSignature', 'LspHover',
          'LspDiagnosticsVirtualText', 'LspDiagnostics',
          'LspDiagnosticsHint', 'LspDiagnosticsError',
          'LspDiagnosticsWarning', 'LspDiagnosticsInformation',
        }
        for _, hl in ipairs(lsp_hls) do
          vim.api.nvim_set_hl(0, hl, { bg = 'none' })
        end
      end

      KeepBackground()
    end,
  }
}


