-- lua/plugin/vimgrep_replace/ui.lua
local state = require("plugin.vimgrep_replace.state")
local keymaps = require("plugin.vimgrep_replace.keymaps")
local utils = require("plugin.vimgrep_replace.utils")
-- TODO: Make sure vsplit does it in floating window buffer. Stream line process of accepting and rejecting a replacement
local M = {}

-- Create a buffer with vertical split
function M.create_split_in_single_buffer(opts)
  -- Dimensions for the floating windows
  local total_width = math.floor(vim.o.columns * 0.8)
  local total_height = math.floor(vim.o.lines * 0.6)
  local split_width = math.floor(total_width / 2) - 1 -- Subtract 1 to account for borders

  -- Calculate the center position for both windows
  local col = math.floor((vim.o.columns - total_width) / 2)
  local row = math.floor((vim.o.lines - total_height) / 2)

  -- Create buffers
  local left_buf = vim.api.nvim_create_buf(false, true)
  local right_buf = vim.api.nvim_create_buf(false, true)

  -- Create the left floating window
  local left_win = utils.setup_floating_window(left_buf, {
    title = "Search",
    title_pos = "center",
    relative = "editor", -- Center relative to the entire editor
    width = split_width,
    height = total_height,
    col = col, -- Start at the calculated center column
    row = row, -- Start at the calculated center row
    style = "minimal",
    border = "rounded"
  }, {
    cursorline = false,
  })

  -- Create the right floating window
  local right_win = utils.setup_floating_window(right_buf, {
    title = "Replace",
    title_pos = "center",
    relative = "editor", -- Center relative to the entire editor
    width = split_width,
    height = total_height,
    col = col + split_width + 2, -- Account for the left window's border
    row = row, -- Same vertical alignment
    style = "minimal",
    border = "rounded"
  }, {
    cursorline = false,
  })

  keymaps.setup_buffer_keymaps({
    left_buf = left_buf,
    right_buf = right_buf,
  }, opts)

  -- Return the context
  return {
    left_buf = left_buf,
    right_buf = right_buf,
    left_win = left_win,
    right_win = right_win,
  }
end

-- Update the content in both splits of the single buffer
function M.set_split_buffer_content(context, file, lnum, col, search_term, replace_with)
  local buf_left = context.left_buf
  local buf_right = context.right_buf
  local left_win = context.left_win
  local right_win = context.right_win

  -- Load the buffer without opening it
  local bufnr = vim.fn.bufadd(file)
  vim.fn.bufload(bufnr)

  -- Fetch 5 lines above and below the match
  local start_line = math.max(lnum - 6, 0)
  local end_line = lnum + 5
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

  if #lines > 0 then
    -- Determine filetype from the file extension
    local filetype = vim.fn.fnamemodify(file, ":e")

    -- Original and updated content with line numbers
    local left_lines = {}
    local right_lines = {}
    for i, line in ipairs(lines) do
      local original_line_number = start_line + i
      local line_number_prefix = string.format("%4d | ", original_line_number)
      table.insert(left_lines, line_number_prefix .. line)
      table.insert(right_lines, line_number_prefix .. line)
    end

    -- Modify the replacement content in the right buffer
    local target_line_index = lnum - start_line
    if target_line_index >= 1 and target_line_index <= #right_lines then
      local prefix = string.format("%4d | ", lnum)
      local target_line = right_lines[target_line_index]:sub(#prefix + 1) -- Remove the line number prefix
      right_lines[target_line_index] =
        prefix .. target_line:sub(1, col - 1) .. replace_with .. target_line:sub(col + #search_term)
    end

    -- Update the buffer content
    vim.api.nvim_buf_set_lines(buf_left, 0, -1, false, left_lines)
    vim.api.nvim_buf_set_lines(buf_right, 0, -1, false, right_lines)

    -- Set filetype for syntax highlighting
    vim.api.nvim_buf_set_option(buf_left, "filetype", filetype)
    vim.api.nvim_buf_set_option(buf_right, "filetype", filetype)

    -- Namespace for highlights
    local ns_id = vim.api.nvim_create_namespace("highlight_replace_preview")

    -- Highlight the search term in the left buffer
    vim.api.nvim_buf_clear_namespace(buf_left, ns_id, 0, -1)
    vim.api.nvim_buf_add_highlight(
      buf_left,
      ns_id,
      "Search",
      target_line_index,
      col - 1 + #string.format("%4d | ", lnum), -- Account for line number prefix
      col - 1 + #string.format("%4d | ", lnum) + #search_term
    )

    -- Highlight the replacement term in the right buffer
    vim.api.nvim_buf_clear_namespace(buf_right, ns_id, 0, -1)
    vim.api.nvim_buf_add_highlight(
      buf_right,
      ns_id,
      "Replace",
      target_line_index,
      col - 1 + #string.format("%4d | ", lnum), -- Account for line number prefix
      col - 1 + #string.format("%4d | ", lnum) + #replace_with
    )

    -- Ensure cursor position is valid and set it for both splits
    local cursor_line = math.min(target_line_index + 1, #left_lines)
    local cursor_col = math.min(col, #(lines[cursor_line] or "")) + #string.format("%4d | ", lnum)
    vim.api.nvim_win_set_cursor(left_win, { cursor_line, cursor_col - 1 })
    vim.api.nvim_win_set_cursor(right_win, { cursor_line, cursor_col - 1 })
  else
    vim.notify("No lines fetched from the buffer.", vim.log.levels.ERROR)
  end
end

return M

