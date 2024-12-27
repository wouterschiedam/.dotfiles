-- lua/plugin/vimgrep_replace/init.lua
-- TESTLINE
local M = {}
local state = require("plugin.vimgrep_replace.state")
local ui = require("plugin.vimgrep_replace.ui")
local actions = require("plugin.vimgrep_replace.actions")

function M.setup(opts)
  opts = opts or {}

  -- Default options for key mappings and behavior
  local keymaps = opts.keymaps or {}
  local search_prompt = opts.search_prompt or "Search term: "
  local replace_prompt = opts.replace_prompt or "Replace with: "

  -- vimgrep (vg) - allows search term entry and searches files
  vim.keymap.set('n', keymaps.vimgrep or '<leader>vg', function()
    -- Prompt the user for a search term
    local search_term = vim.fn.input(search_prompt)

    if search_term and search_term ~= '' then
      -- Store the search term for later use
      state.set_search_term(search_term)

      -- Execute vimgrep in the current working directory for all file types
      vim.cmd('vimgrep /' .. search_term .. '/ **/* | copen')
    else
      print('Search term cannot be empty!')
    end
  end, { noremap = true, silent = true, desc = 'Search using vimgrep in current directory' })

  -- quickfix replace (qr) - replaces search term with the user input
  vim.keymap.set("n", keymaps.replace or "<leader>qr", function()
    actions.replace_quickfix(replace_prompt)
  end, { noremap = true, silent = true, desc = "Replace matches in quickfix list" })
end

M.setup()

