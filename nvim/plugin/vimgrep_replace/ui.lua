-- lua/plugin/vimgrep_replace/ui.lua
-- TODO: Make sure vsplit does it in floating window buffer. Stream line process of accepting and rejecting a replacement
local M = {}

-- Create a single buffer with vertical split
function M.create_split_in_single_buffer()
  local total_width = math.floor(vim.o.columns * 0.8)
  local total_height = math.floor(vim.o.lines * 0.5)

  local col = math.floor((vim.o.columns - total_width) / 2)
  local row = math.floor((vim.o.lines - total_height) / 2)

  -- Create a buffer
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

  -- Define window configuration for the main floating window
  local win_config = {
    relative = "editor",
    width = total_width,
    height = total_height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  -- Create the main floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  vim.api.nvim_set_current_win(win)

  -- Split the window into two using :vsplit
  vim.api.nvim_win_set_option(win, "splitright", true) -- Ensure splits go to the right
  vim.cmd("vsplit")
  local split_win = vim.api.nvim_get_current_win()

  -- Return the buffer and both window handles
  return { buf = buf, left_win = win, right_win = split_win }
end

-- Update the content in both splits of the single buffer
function M.set_split_buffer_content(context, file, lnum, col, search_term, replace_with)
  local buf = context.buf
  local left_win = context.left_win
  local right_win = context.right_win

  -- Load the buffer without opening it
  local bufnr = vim.fn.bufadd(file)
  vim.fn.bufload(bufnr)

  -- Fetch 5 lines above and below the match
  local start_line = math.max(lnum - 6, 0)
  local end_line = lnum + 5
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

  -- Ensure we have valid lines
  if #lines > 0 then
    -- Determine filetype from the file extension
    local filetype = vim.fn.fnamemodify(file, ":e")

    -- Original content for the left split
    local left_lines = vim.deepcopy(lines)
    table.insert(left_lines, "")
    table.insert(left_lines, "[y] Accept | [n] Decline")

    -- Updated content for the right split
    local right_lines = vim.deepcopy(lines)
    local target_line_index = lnum - start_line - 1
    if target_line_index >= 0 and target_line_index < #right_lines then
      right_lines[target_line_index + 1] =
        right_lines[target_line_index + 1]:sub(1, col - 1) .. replace_with .. right_lines[target_line_index + 1]:sub(col + #search_term)
    end

    table.insert(right_lines, "")
    table.insert(right_lines, "[y] Accept | [n] Decline")

    -- Update the buffer content and set the view for the left split
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, left_lines)
    vim.api.nvim_win_set_cursor(left_win, { lnum, col })

    -- Set the view for the right split and update the replacement
    vim.api.nvim_set_current_win(right_win)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, right_lines)
    vim.api.nvim_win_set_cursor(right_win, { lnum, col })

    -- Set filetype for syntax highlighting
    vim.api.nvim_buf_set_option(buf, "filetype", filetype)

    -- Highlight the match in the left split
    local ns_id = vim.api.nvim_create_namespace("highlight_replace_preview")
    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "ErrorMsg", target_line_index, col - 1, col - 1 + #search_term)

    -- Highlight the replacement in the right split
    vim.api.nvim_buf_add_highlight(buf, ns_id, "Search", target_line_index, col - 1, col - 1 + #replace_with)
  end
end

return M

