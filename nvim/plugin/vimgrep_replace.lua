-- lua/plugin/vimgrep_replace.lua
-- TESTLINE
local M = {}

-- Table to store shared state between keymaps
local vimgrep_state = {}

-- Create two side-by-side floating windows
local function create_split_floating_window(padding)
  local total_width = math.floor(vim.o.columns * 0.8)
  local total_height = math.floor(vim.o.lines * 0.5)
  local left_width = math.floor(total_width / 2) - math.floor(padding / 2)
  local right_width = total_width - left_width - padding

  local col = math.floor((vim.o.columns - total_width) / 2)
  local row = math.floor((vim.o.lines - total_height) / 2)

  -- Create left buffer and window for original content
  local left_buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  local left_win_config = {
    relative = "editor",
    width = left_width,
    height = total_height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  local left_win = vim.api.nvim_open_win(left_buf, true, left_win_config)

  -- Create right buffer and window for updated content
  local right_buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  local right_win_config = {
    relative = "editor",
    width = right_width,
    height = total_height,
    col = col + left_width + padding,
    row = row,
    style = "minimal",
    border = "rounded",
  }
  local right_win = vim.api.nvim_open_win(right_buf, true, right_win_config)

  return { left = { buf = left_buf, win = left_win }, right = { buf = right_buf, win = right_win } }
end

-- Update the content for both splits
local function set_split_floating_window_content(context, file, lnum, col, search_term, replace_with)
  local left_buf = context.left.buf
  local right_buf = context.right.buf

  -- Load the buffer without opening it
  local bufnr = vim.fn.bufadd(file)
  vim.fn.bufload(bufnr)

  -- Fetch 5 lines above and below the match
  local start_line = math.max(lnum - 6, 0)
  local end_line = lnum + 5
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

  -- Ensure we have valid lines
  if #lines > 0 then
    -- Original content for the left split
    local left_lines = vim.deepcopy(lines)
    table.insert(left_lines, "") -- Add an empty line for spacing
    table.insert(left_lines, "Original") -- Footer label
    vim.api.nvim_buf_set_lines(left_buf, 0, -1, false, left_lines)
    vim.api.nvim_buf_set_option(left_buf, "filetype", vim.fn.fnamemodify(file, ":e"))

    -- Updated content for the right split
    local right_lines = vim.deepcopy(lines) -- Copy lines to avoid modifying the original
    local target_line_index = lnum - start_line - 1 -- Convert lnum to 0-based index for array
    if target_line_index >= 0 and target_line_index < #right_lines then
      right_lines[target_line_index + 1] =
        right_lines[target_line_index + 1]:sub(1, col - 1) .. replace_with .. right_lines[target_line_index + 1]:sub(col + #search_term)
    end
    table.insert(right_lines, "") -- Add an empty line for spacing
    table.insert(right_lines, "Modified") -- Footer label
    vim.api.nvim_buf_set_lines(right_buf, 0, -1, false, right_lines)
    vim.api.nvim_buf_set_option(right_buf, "filetype", vim.fn.fnamemodify(file, ":e"))

    -- Highlight the match in the left buffer
    local ns_id = vim.api.nvim_create_namespace("highlight_replace_preview")
    vim.api.nvim_buf_clear_namespace(left_buf, ns_id, 0, -1)
    vim.api.nvim_buf_add_highlight(left_buf, ns_id, "ErrorMsg", target_line_index, col - 1, col - 1 + #search_term)

    -- Highlight the replacement in the right buffer
    vim.api.nvim_buf_clear_namespace(right_buf, ns_id, 0, -1)
    vim.api.nvim_buf_add_highlight(right_buf, ns_id, "Search", target_line_index, col - 1, col - 1 + #replace_with)
  end
end

local function handle_user_input_splits(context, bufnr, lnum, col, updated_line, quickfix_list, index)
  -- Set keymaps for 'y' (accept) and 'n' (decline) in the left window
  local opts = { noremap = true, silent = true, nowait = true }

  -- Accept replacement
  vim.api.nvim_buf_set_keymap(context.left.buf, "n", "y", "", {
    noremap = true,
    silent = true,
    callback = function()
      -- Apply the replacement
      vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { updated_line })

      -- Save the buffer
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("write")
      end)

      -- Remove the entry from the quickfix list
      table.remove(quickfix_list, index)

      -- Close both windows
      vim.api.nvim_win_close(context.left.win, true)
      vim.api.nvim_win_close(context.right.win, true)
    end,
  })

  -- Decline replacement
  vim.api.nvim_buf_set_keymap(context.left.buf, "n", "n", "", {
    noremap = true,
    silent = true,
    callback = function()
      -- Close both windows
      vim.api.nvim_win_close(context.left.win, true)
      vim.api.nvim_win_close(context.right.win, true)
    end,
  })
end

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


  vim.keymap.set("n", keymaps.replace or "<leader>qr", function()
    local search_term = vimgrep_state.search_term
    if not search_term or search_term == "" then
      print("No search term found! Run <leader>vg first.")
      return
    end

    local replace_with = vim.fn.input(string.format(replace_prompt, search_term))
    if replace_with == "" then
      print("Replacement cannot be empty")
      return
    end

    local quickfix_list = vim.fn.getqflist()

    if vim.tbl_isempty(quickfix_list) then
      print("Quickfix is empty!")
      return
    end

    local context = create_split_floating_window(2.0)
    for i = #quickfix_list, 1, -1 do
      local entry = quickfix_list[i]
      local file = entry.bufnr and vim.fn.bufname(entry.bufnr) or entry.filename

      if file and file ~= "" then
        local lnum = entry.lnum
        local col = entry.col
        local bufnr = vim.fn.bufadd(file)
        vim.fn.bufload(bufnr)

        local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
        if #lines > 0 then
          local current_line = lines[1]
          local updated_line = current_line:sub(1, col - 1) .. replace_with .. current_line:sub(col + #search_term)

          set_split_floating_window_content(context, file, lnum, col, search_term, replace_with)
          handle_user_input_splits(context, bufnr, lnum, col, updated_line, quickfix_list, i)
          return -- Show one replacement at a time
        end
      end
    end
  end, { noremap = true, silent = true, desc = "Replace matches in quickfix list" })

end

M.setup()
