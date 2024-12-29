-- lua/plugin/vimgrep_replace/keymaps.lua
local M = {}

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
      -- TODO: Fix exclude_cmd and include cmd
      local temp_search = vim.split(search_term, " ")
      search_term = temp_search[1]
      local directory

      if #temp_search > 1 then
        directory = temp_search[2]
      end

      state.set_search_term(search_term)
      state.set_dir(directory)

      local excluded_dirs = state.get_excluded_dir()
      local exclude_cmd = ""

      for _, dir in ipairs(excluded_dirs) do
        exclude_cmd = exclude_cmd .. '--exclude-dir=' .. vim.fn.shellescape(dir) .. " "
      end

      -- Find all matching files
      local command = 'grep -n -r ' .. exclude_cmd .. '"' .. search_term .. '" "' .. directory .. '"'
      print(command)
      local results = vim.fn.systemlist(command)

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

  -- Keybinding for toggling between the floating windows
  vim.api.nvim_buf_set_keymap(context.left_buf, "n", keymaps.buffer.toggle,
  ":lua require('plugin.vimgrep_replace.actions').focus_window_from_state(" .. context.right_buf .. ")<CR>",
  { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(context.right_buf, "n", keymaps.buffer.toggle,
  ":lua require('plugin.vimgrep_replace.actions').focus_window_from_state(" .. context.left_buf .. ")<CR>",
  { noremap = true, silent = true })

  -- Keybinding for accepting the replacement
  vim.api.nvim_buf_set_keymap(context.right_buf, "n", keymaps.buffer.accept, ":lua require('plugin.vimgrep_replace.actions').accept_change()<CR>", { noremap = true, silent = true })

  -- Keybinding for rejecting the replacement
  vim.api.nvim_buf_set_keymap(context.right_buf, "n", keymaps.buffer.decline, ":lua require('plugin.vimgrep_replace.actions').decline_change()<CR>", { noremap = true, silent = true })

  -- Keybinding for canceling the replacement
  vim.api.nvim_buf_set_keymap(context.right_buf, "n", keymaps.buffer.cancel, ":lua require('plugin.vimgrep_replace.actions').cancel_process()<CR>", { noremap = true, silent = true })

  -- Keybinding for canceling the replacement
  vim.api.nvim_buf_set_keymap(context.right_buf, "n", keymaps.buffer.skip, ":lua require('plugin.vimgrep_replace.actions').skip_change()<CR>", { noremap = true, silent = true })
end

return M

