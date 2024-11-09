-- Load the colorscheme
vim.cmd.colorscheme("catppuccin-frappe");

function DoRecolor(color)
    color = color or "rose-pine";
    vim.cmd.colorscheme(color)
    KeepBackground()
end

function KeepBackground()
    vim.api.nvim_set_hl(0, 'Normal', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'NormalFloat', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'NormalNC', {bg = 'none'})  -- for non-current windows

    -- Background for split windows (horizontal and vertical)
    vim.api.nvim_set_hl(0, 'VertSplit', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'WinSeparator', {bg = 'none'})

    -- Background for floating windows and popups
    vim.api.nvim_set_hl(0, 'FloatBorder', {bg = 'none'})

    -- Telescope window background removal
    vim.api.nvim_set_hl(0, 'TelescopeNormal', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'TelescopeBorder', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'TelescopePromptNormal', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', {bg = 'none'})

    -- Popup windows like `vim.lsp` and `nvim-compe`
    vim.api.nvim_set_hl(0, 'Pmenu', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'PmenuSel', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'PmenuSbar', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'PmenuThumb', {bg = 'none'})

    -- Diff and Terminal windows
    vim.api.nvim_set_hl(0, 'DiffAdd', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'DiffChange', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'DiffDelete', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'Terminal', {bg = 'none'})

    -- Set transparent background for LSP-related windows
    vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspSignature', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspHover', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspDiagnosticsVirtualText', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspDiagnostics', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspDiagnosticsHint', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspDiagnosticsError', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspDiagnosticsWarning', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'LspDiagnosticsInformation', {bg = 'none'})
end

KeepBackground()
