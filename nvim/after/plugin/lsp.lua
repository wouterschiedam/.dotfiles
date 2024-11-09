local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
      'html',
      'cssls',
      'rust_analyzer',
      'ts_ls',
      'omnisharp',
      'intelephense'
    },
  handlers = {
    lsp_zero.default_setup,
  },
})
lsp_zero.format_on_save({
  format_opts = {
    async = true,
    timeout_ms = 10000,
  },
  servers = {
    ['ts_ls'] = {'javascript', 'typescript'},
    ['rust_analyzer'] = {'rust'},
    ['intelephense'] = {'php'},
    ['omnisharp'] = {'csharp'}
  }
})

require('lspconfig').intelephense.setup({
  -- Set space size crashes on FiveX Repo
  cmd = { "node", "--max-old-space-size=4096", vim.fn.expand("~/.local/share/nvim/mason/bin/intelephense"), "--stdio" },
  root_dir = function(fname)
    return require('lspconfig').util.find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  init_options = {
    licenseKey = vim.fn.expand('~/intelephense/license.txt'),
  },
})


require('lspconfig').rust_analyzer.setup({
settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true;
      },
      inlayHints = true
    }
  }
})

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>i", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "<leader>e", function() vim.diagnostic.setloclist() end, opts)
end)

lsp_zero.setup()
