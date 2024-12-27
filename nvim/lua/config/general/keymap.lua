-- Netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Jumping pages keeps cursor in the middle
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Keep search terms in the middle of the screen
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Jump to next search term' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Jump to previous search term' })

-- when selected move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Pastes copied buffer and keeps it in the register
vim.keymap.set('x', '<leader>p', '\"_dP')

-- Toggle highlighting search
vim.keymap.set('n', '<leader>;h', ':set hlsearch!<CR>', { desc = 'Toggle highlighting search' })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- FullScreen
vim.api.nvim_set_keymap('n', '<leader>fs', '<C-w>|', { noremap = true, silent = true })
-- ExitFullscreen
vim.api.nvim_set_keymap('n', '<leader>rs', '<C-w>=', { noremap = true, silent = true })

-- Define the FormatFiles function
local function FormatFiles(directory, file_pattern)
  -- Expand to absolute path
  directory = vim.fn.expand(directory)

  -- Find all files matching the pattern in the directory
  local files = vim.fn.globpath(directory, '**/' .. file_pattern, false, true)

  if #files == 0 then
    print('No files found matching "' .. file_pattern .. '" in ' .. directory)
    return
  end

  for _, file in ipairs(files) do
    -- Open the file
    vim.cmd('silent! edit ' .. file)

    -- Check if an LSP client is attached
    if not vim.tbl_isempty(vim.lsp.get_cliens()) then
      -- Format the file using LSP
      vim.lsp.buf.format({ async = false })
    else
      print('No LSP client attached for file: ' .. file)
    end

    -- Save the file
    vim.cmd('silent! write')
  end

  print('Formatted ' .. #files .. ' files matching "' .. file_pattern .. '" in ' .. directory)
end

-- Create the custom command
vim.api.nvim_create_user_command(
'FormatFiles',
function(opts)
  -- First argument: directory
  local dir = opts.fargs[1] or vim.fn.getcwd()

  -- Second argument: file pattern
  local pattern = opts.fargs[2] or '*'

  -- Call the FormatFiles function
  FormatFiles(dir, pattern)
end,
{ nargs = '*' } -- Allow 0 or more arguments
)

-- Fast terminal
local job_id = 0
vim.keymap.set("n", "<space>to", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 5)

  job_id = vim.bo.channel
end)

local current_command = ""
vim.keymap.set("n", "<space>te", function()
  current_command = vim.fn.input("Command: ")
end)

vim.keymap.set("n", "<space>tr", function()
  if current_command == "" then
    current_command = vim.fn.input("Command: ")
  end

  vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)

vim.g.python3_host_prog = '/opt/homebrew/bin/python3'
