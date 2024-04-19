vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Jumping pages keeps cursor in the middle
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Keep search terms in the middle of the screen
vim.keymap.set('n', 'n', 'nzzzv', {desc = 'Jump to next search term'})
vim.keymap.set('n', 'N', 'Nzzzv', {desc = 'Jump to previous search term'})

-- when selected move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Pastes copied buffer and keeps it in the register
vim.keymap.set('x', '<leader>p', '\"_dP')

-- Toggle highlighting search
vim.keymap.set('n', '<leader>;h', ':set hlsearch!<CR>', {desc = 'Toggle highlighting search'})

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Vim Wiki split
vim.api.nvim_set_keymap('n', '<leader>ww', ':vsplit | VimwikiIndex<CR>', { noremap = true, silent = true, desc = 'Vimwiki split' })

-- Vim diagnostics
vim.api.nvim_set_keymap("n", "<leader>i", ":lua vim.diagnostic.open_float(nil, {focus=true, scope='cursor'})<CR>", {noremap = true, silent = true})

-- default splits
-- FullScreen
vim.api.nvim_set_keymap('n', '<leader>ff', '<C-w>|', { noremap = true, silent = true })
-- ExitFullscreen
vim.api.nvim_set_keymap('n', '<leader>rr', '<C-w>=', { noremap = true, silent = true })
