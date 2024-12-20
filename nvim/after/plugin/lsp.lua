-- lua/lsp-zero-config.lua

local lsp_zero = require('lsp-zero')

local function diagnostics_to_quickfix()
    vim.diagnostic.setqflist({ open = true })
end
-- Initialize lsp-zero with recommended settings
lsp_zero.preset('recommended')

-- Setup Mason and Mason-LSPConfig
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'html',
        'cssls',
        'rust_analyzer',
        'omnisharp',
        'intelephense'
    },
    handlers = {
        lsp_zero.default_setup,
    },
})

-- Define on_attach for keymaps and other settings
lsp_zero.on_attach(function(client, bufnr)
    -- Disable formatting from Intelephense to use null-ls instead
    if client.name == "intelephense" then
        client.server_capabilities.documentFormattingProvider = false
    end

    -- Set default keymaps
    lsp_zero.default_keymaps({ buffer = bufnr })

    -- Additional keymaps
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>i", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>q", diagnostics_to_quickfix, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.setloclist, opts)

end)


-- Setup specific LSP servers with custom configurations
-- Intelephense (PHP)
require('lspconfig').intelephense.setup({
    cmd = { "node", "--max-old-space-size=4096", vim.fn.expand("~/.local/share/nvim/mason/bin/intelephense"), "--stdio" },
    root_dir = function(fname)
        return require('lspconfig').util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    on_attach = function(client, bufnr)
        -- Disable LSP formatting for PHP
        client.server_capabilities.documentFormattingProvider = false
    end,
    init_options = {
        licenseKey = vim.fn.expand('~/intelephense/license.txt'),
    },
    -- on_attach is handled by lsp-zero's on_attach
})

-- Rust Analyzer
require('lspconfig').rust_analyzer.setup({
    cmd = { "rust-analyzer" },
    root_dir = vim.loop.cwd,
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                env = {
                    LIBTORCH_USE_PYTORCH = "1",
                    LIBTORCH_BYPASS_VERSION_CHECK = "1",
                },
            },
            diagnostics = {
                enable = true,
            },
            inlayHints = {
                enable = true
            }
        }
    },
    -- on_attach is handled by lsp-zero's on_attach
})

-- Finalize lsp-zero setup
lsp_zero.setup()

