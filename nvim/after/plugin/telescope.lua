local builtin = require('telescope.builtin')

vim.keymap.set("n", "<leader>vm", require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>lg', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
