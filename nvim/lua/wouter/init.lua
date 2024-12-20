require("wouter.lazy")
require("wouter.remap")
require("wouter.set")

-- Define the FormatFiles function
local function FormatFiles(path, command)
  vim.cmd('args ' .. path)
  vim.cmd('argdo ' .. command .. ' | update')
end

-- Create the custom command
vim.api.nvim_create_user_command(
  'FormatFiles',
  function(opts)
    FormatFiles(opts.fargs[1], table.concat(opts.fargs, ' ', 2))
  end,
  { nargs = '+' }
)
