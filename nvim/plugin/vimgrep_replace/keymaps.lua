-- lua/plugin/vimgrep_replace/keymaps.lua
local M = {}

local mappings = {
  toggle = "<Tab>", -- Default key for toggling windows
  accept = "<CR>", -- Default key for accepting changes
  decline = "<Esc>", -- Default key for declining changes
}

function M.setup_global_keymaps(opts)
  opts = opts or {}

  local keymaps = opts.keymaps or {}
  local search_prompt = opts.search_prompt or "Search term: "
  local replace_prompt = opts.replace_prompt or "Replace with: "
  local state = require("plugin.vimgrep_replace.state")
  local actions = require("plugin.vimgrep_replace.actions")

  -- vimgrep (vg) - allows search term entry and searches files
vim.keymap.set('n', keymaps.vimgrep or '<leader>vg', function()
  local search_term = vim.fn.input(search_prompt)

  if search_term and search_term ~= '' then
    state.set_search_term(search_term)

    -- Find all matching files
    local results = vim.fn.systemlist('grep -n -r "' .. search_term .. '" .')

    -- Parse results and populate the quickfix list
    local qf_entries = {}
    for _, result in ipairs(results) do
      local filepath, lnum, match = result:match("([^:]+):(%d+):(.*)")
      if filepath and lnum and match then
        table.insert(qf_entries, {
          filename = filepath,
          lnum = tonumber(lnum),
          text = match,
        })
      end
    end

    if #qf_entries > 0 then
      vim.fn.setqflist(qf_entries, 'r') -- Replace the quickfix list with the new entries
      vim.cmd('copen') -- Open the quickfix list without opening files
    else
      print('No matches found for "' .. search_term .. '"')
    end
  else
    print('Search term cannot be empty!')
  end
end, { noremap = true, silent = true, desc = 'Search using vimgrep in current directory' })

  -- quickfix replace (qr) - replaces search term with the user input
  vim.keymap.set("n", keymaps.replace or "<leader>qr", function()
    actions.replace_quickfix(replace_prompt)
  end, { noremap = true, silent = true, desc = "Replace matches in quickfix list" })
end

function M.setup_buffer_keymaps(context, keymaps)
  keymaps = keymaps or { toggle = "<Tab>" }

  -- Keybinding for toggling between the floating windows
  vim.api.nvim_buf_set_keymap(context.left_buf, "n", keymaps.toggle, "<Cmd>wincmd w<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(context.right_buf, "n", keymaps.toggle, "<Cmd>wincmd w<CR>", { noremap = true, silent = true })
end

return M

