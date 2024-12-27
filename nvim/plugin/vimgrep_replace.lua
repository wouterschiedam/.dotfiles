-- lua/plugin/vimgrep_replace.lua
local M = {}

-- Table to store shared state between keymaps
local vimgrep_state = {}

-- Setup function to allow user configuration
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
      vimgrep_state.search_term = search_term

      -- Execute vimgrep in the current working directory for all file types
      vim.cmd('vimgrep /' .. search_term .. '/ **/* | copen')
    else
      print('Search term cannot be empty!')
    end
  end, { noremap = true, silent = true, desc = 'Search using vimgrep in current directory' })

  -- quickfix replace (qr) - replaces search term with the user input
  vim.keymap.set('n', keymaps.replace or '<leader>qr', function()
    -- Fetch the search term from vimgrep
    local search_term = vimgrep_state.search_term
    if not search_term or search_term == '' then
      print('No search term found! Run <leader>vg first.')
      return
    end

    -- Prompt for replacement
    local replace_with = vim.fn.input(string.format(replace_prompt, search_term))
    if replace_with == '' then
      print('Replacement cannot be empty')
      return
    end

    -- Fetch the current quickfix list
    local quickfix_list = vim.fn.getqflist()

    if vim.tbl_isempty(quickfix_list) then
      print('Quickfix is empty!')
      return
    end

    -- TODO: Make floating window to show preview

    -- Iterate over each item in quickfix list
    for i = #quickfix_list, 1, -1 do
      local entry = quickfix_list[i]
      local file = entry.bufnr and vim.fn.bufname(entry.bufnr) or entry.filename

      if not file or file == '' then
        print('Skipping entry without a valid file')
      else
        local lnum = entry.lnum
        local col = entry.col
        local text = vimgrep_state.search_term

        local choice = vim.fn.input(
          string.format('Replace "%s" in file %s at line %d for %s? (y/n): ', text, file, lnum, replace_with)
        )

        if choice:lower() == 'y' then
          -- Load the buffer without opening it
          local bufnr = vim.fn.bufadd(file)
          vim.fn.bufload(bufnr)

          -- Access the line in the buffer
          local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
          if #lines > 0 then
            local current_line = lines[1]

            -- Identify the specific word to replace based on the column
            local before = current_line:sub(1, col - 1) -- Text before the match
            local after = current_line:sub(col + #text) -- Text after the match
            local match = current_line:sub(col, col + #text - 1) -- The exact matched word

            if match == text then
              -- Construct the updated line
              local updated_line = before .. replace_with .. after

              -- Update the buffer line
              vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { updated_line })

              -- Save the buffer
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd('write')
              end)

              -- Remove the entry from the quickfix list after processing
              table.remove(quickfix_list, i)
            else
              print(string.format('No exact match for "%s" at line %d in %s', text, lnum, file))
            end
          else
            print('Failed to retrieve line ' .. lnum .. ' in file ' .. file)
          end
        end
      end
    end

    -- Update the quickfix list with the modified list (without the replaced entries)
    vim.fn.setqflist(quickfix_list, 'r')
  end, { noremap = true, silent = true, desc = "Replace matches in quickfix list" })
end

M.setup()
