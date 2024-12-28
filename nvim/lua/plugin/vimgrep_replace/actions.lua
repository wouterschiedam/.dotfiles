-- lua/plugin/vimgrep_replace/actions.lua
local state = require("plugin.vimgrep_replace.state")
local ui = require("plugin.vimgrep_replace.ui")
local keymaps = require("plugin.vimgrep_replace.keymaps")

local M = {}

function M.preview_next_change()
  local quickfix_list = vim.fn.getqflist()
  local current_index = state.get_current_index()

  if current_index > #quickfix_list then
    vim.notify("All changes reviewed.", vim.log.levels.INFO)
    local context = state.get_context()
    if context then
      vim.api.nvim_win_close(context.left_win, true)
      vim.api.nvim_win_close(context.right_win, true)
      vim.cmd("cclose") -- Close quickfix window
    end
    state.set_context(nil)
    return
  end

  local entry = quickfix_list[current_index]
  local file = entry.bufnr and vim.fn.bufname(entry.bufnr) or entry.filename
  local context = state.get_context()

  ui.set_split_buffer_content(context, file, entry.lnum, entry.col, state.get_search_term(), state.get_replacement())

  if not context then
    print("Context cannot be a nill value...")
    return
  end

  keymaps.setup_buffer_keymaps(state.get_buffers(), state.get_options().keymaps)
end

function M.accept_change()
  local current_index = state.get_current_index()
  local quickfix_list = vim.fn.getqflist()

  -- Ensure the quickfix list is not empty
  if #quickfix_list == 0 then
    vim.notify("Quickfix list is empty.", vim.log.levels.WARN)
    return
  end

  -- Ensure the current index is within bounds
  if current_index < 1 or current_index > #quickfix_list then
    vim.notify("Invalid quickfix index: " .. current_index, vim.log.levels.ERROR)
    return
  end

  -- Get the current quickfix entry
  local entry = quickfix_list[current_index]
  if not entry or not entry.bufnr or not entry.lnum then
    vim.notify("Invalid quickfix entry at index " .. current_index .. ": " .. vim.inspect(entry), vim.log.levels.ERROR)
    return
  end

  -- Retrieve the filename using bufnr
  local filename = vim.fn.bufname(entry.bufnr)
  if filename == "" then
    vim.notify("Could not determine filename for buffer number: " .. entry.bufnr, vim.log.levels.ERROR)
    return
  end

  -- Open the buffer for the file
  local bufnr = entry.bufnr
  vim.fn.bufload(bufnr)

  -- Get the line to replace
  local lines = vim.api.nvim_buf_get_lines(bufnr, entry.lnum - 1, entry.lnum, false)
  if #lines == 0 then
    vim.notify("Failed to load the line from the buffer.", vim.log.levels.ERROR)
    return
  end

  local line = lines[1]
  local search_term = state.get_search_term()
  local replacement = state.get_replacement()

  -- Find the positions of the search term
  local start_pos, end_pos
  if search_term then
    start_pos, end_pos = line:find(search_term, 1, true)
    if not start_pos or not end_pos then
      vim.notify("Search term not found in the line: " .. line, vim.log.levels.WARN)
      return
    end
  end

  -- Construct the new line with the replacement
  local before = line:sub(1, start_pos - 1) -- Everything before the search term
  local after = line:sub(end_pos + 1)      -- Everything after the search term
  local new_line = before .. replacement .. after

  -- Update the line in the buffer
  vim.api.nvim_buf_set_lines(bufnr, entry.lnum - 1, entry.lnum, false, { new_line })

  -- Save the buffer to persist the change
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("write")
  end)

  -- Remove the current quickfix entry
  table.remove(quickfix_list, current_index)
  vim.fn.setqflist(quickfix_list, 'r')

  -- Move to the next quickfix entry
  state.set_current_index(current_index)
  M.preview_next_change()
end

function M.decline_change()
  local current_index = state.get_current_index()
  state.set_current_index(current_index + 1)
  M.preview_next_change()
end

function M.cancel_process()
  local context = state.get_context()
  if context then
    vim.api.nvim_win_close(context.left_win, true)
    vim.api.nvim_win_close(context.right_win, true)
  end
  state.set_context(nil)
  vim.notify("Operation canceled.", vim.log.levels.WARN)
end

function M.replace_quickfix(replace_prompt)
  local search_term = state.get_search_term()
  if not search_term or search_term == "" then
    print("No search term found! Run <leader>vg first.")
    return
  end

  local replace_with = vim.fn.input(string.format(replace_prompt, search_term))
  if replace_with == "" then
    print("Replacement cannot be empty")
    return
  end

  state.set_replacement(replace_with)

  local quickfix_list = vim.fn.getqflist()

  if vim.tbl_isempty(quickfix_list) then
    print("Quickfix is empty!")
    return
  end

  local context = ui.create_split_in_single_buffer()
  state.set_context(context)
  state.set_current_index(1)

  -- Preview the first match
  M.preview_next_change()
end

function M.focus_window_from_state(target_buf)
    -- Ensure context is set
    local buf = state.get_context()

    if not buf then
        vim.notify("State context is not properly initialized.", vim.log.levels.ERROR)
        return
    end

    -- Get the current buffer and its corresponding window
    local target_win
    if target_buf == buf.left_buf then
        target_win = buf.left_win
    elseif target_buf == buf.right_buf then
        target_win = buf.right_win
    else
        vim.notify("Buffer is not part of the floating windows in the state.", vim.log.levels.WARN)
        return
    end

    -- Ensure the target window is valid
    if vim.api.nvim_win_is_valid(target_win) then
        vim.api.nvim_set_current_win(target_win)
    else
        vim.notify("Target window is no longer valid.", vim.log.levels.ERROR)
    end
end


return M
