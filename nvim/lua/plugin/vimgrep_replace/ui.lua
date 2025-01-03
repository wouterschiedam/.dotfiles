-- lua/plugin/vimgrep_replace/ui.lua
-- KOEKOEK
local state = require("plugin.vimgrep_replace.state")
local utils = require("plugin.vimgrep_replace.utils")
local M = {}

local function calculate_centered_window(total_width, total_height)
  -- Calculate center positions based on full editor dimensions
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines - vim.fn.winheight(0) + vim.fn.winheight(0) -- Usable lines
  local center_col = math.floor((editor_width - total_width) / 2)
  local center_row = math.floor((editor_height - total_height) / 2) / 2

  return center_col, center_row
end

-- Create a buffer with vertical split
function M.create_split_in_single_buffer()

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
    },
    {
      cursorline = false,
      winhighlight = "FloatBorder:leftwin,FloatTitle:leftwin",
    }
  )

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
    },
    {
      cursorline = false,
      winhighlight = "FloatBorder:rightwin,FloatTitle:rightwin",
    }
  )

  state.set_buffers({
    left_buf = left_buf,
    right_buf = right_buf,
  })

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
  local bufnr = vim.fn.bufadd(file)
  vim.fn.bufload(bufnr)

  -- Fetch lines around the target line
  local start_line = math.max(lnum - 6, 0)
  local end_line = lnum + 10
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

  if #lines > 0 then
    local left_lines = {}
    local right_lines = {}

    -- Prepare lines with prefix for both buffers
    for i, line in ipairs(lines) do
      local original_line_number = start_line + i
      local prefix = string.format("%4d | ", original_line_number)
      table.insert(left_lines, prefix .. line)
      table.insert(right_lines, prefix .. line)
    end

    -- Perform replacement on the target line in the right buffer
    local target_line_index = lnum - start_line - 1
    local start_pos, end_pos
    if target_line_index >= 0 and target_line_index < #right_lines then

      local original_line = right_lines[target_line_index + 1]
      -- Search for the search term in the line using Lua's pattern matching
      start_pos, end_pos = original_line:find(search_term, 1, true) -- Plain search, no patterns

      if start_pos and end_pos then
        -- Construct the new line with the replacement
        local before = original_line:sub(1, start_pos - 1) -- Everything before the search term
        local after = original_line:sub(end_pos + 1) -- Everything after the search term

        -- Replace the target line with the new content
        right_lines[target_line_index + 1] = before .. replace_with .. after
      else
        vim.notify("Search term not found in the line: " .. original_line, vim.log.levels.WARN)
      end
    end

    -- Update both buffers with the prepared lines
    vim.api.nvim_buf_set_lines(buf_left, 0, -1, false, left_lines)
    vim.api.nvim_buf_set_lines(buf_right, 0, -1, false, right_lines)

    -- Get the filetype for syntax highlighting
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    vim.api.nvim_buf_set_option(buf_left, "filetype", filetype)
    vim.api.nvim_buf_set_option(buf_right, "filetype", filetype)

    -- Apply highlight groups
    local ns_id = vim.api.nvim_create_namespace("vimgrep_replace")
    local hl_group = state.get_highlight_group()

    -- Adjust offsets for highlighting
    -- Use the dynamic offsets from `find` for highlighting
    local search_start = start_pos - 1 -- Convert to 0-based index for Vim highlighting
    local search_end = end_pos        -- End position is inclusive in `find`

    -- Debugging
    -- utils.print_highlight_group(hl_group.search)
    -- utils.print_highlight_group(hl_group.replace)

    -- Calculate the replacement offsets
    local replace_start = search_start
    local replace_end = replace_start + #replace_with

    -- Highlight the search term in the left buffer
    vim.api.nvim_buf_add_highlight(
      buf_left,
      ns_id,
      hl_group.search,
      target_line_index,
      search_start,
      search_end
    )

    -- Highlight the replacement term in the right buffer
    vim.api.nvim_buf_add_highlight(
      buf_right,
      ns_id,
      hl_group.replace,
      target_line_index,
      search_start,
      replace_end
    )

    -- Place the cursor on the target line in both splits
    local cursor_pos = { target_line_index + 1, search_start }
    vim.api.nvim_win_set_cursor(context.left_win, cursor_pos)
    vim.api.nvim_win_set_cursor(context.right_win, cursor_pos)
  else
    vim.notify("No lines fetched from buffer for preview.", vim.log.levels.ERROR)
  end
end

function M.create_input_window(title, callback)
  local buffer = vim.api.nvim_create_buf(false, true)

  local total_width = math.floor(vim.o.columns * 0.8) / 3
  local total_height = 1
  local center_col, center_row = calculate_centered_window(total_width, total_height)

  -- Create a floating window
  local win = utils.setup_floating_window(buffer, {
    relative = "editor", -- Center relative to the entire editor
    width = total_width,
    height = total_height,
    col = center_col,
    row = center_row,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
  },{
    cursorline = false,
    winhighlight = "FloatBorder:global,FloatTitle:global",
  })


  local function cleanup()
    if vim.api.nvim_buf_is_valid(buffer) then
      vim.api.nvim_buf_delete(buffer, { force = true })
    end
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.api.nvim_create_autocmd({ "BufLeave", "WinClosed" }, {
    buffer = buffer,
    once = true,
    callback = cleanup,
  })

  -- Configure the buffer
  vim.api.nvim_buf_set_option(buffer, 'buftype', 'prompt')
  vim.api.nvim_buf_set_keymap(buffer, 'i', '<CR>', '', {
    noremap = true,
    silent = true,
    callback = function()
      local input = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1] or ""
      vim.api.nvim_win_close(win, true) -- Close the floating window
      if vim.api.nvim_buf_is_valid(buffer) then
        vim.api.nvim_buf_delete(buffer, { force = true }) -- Delete the buffer
      end
      if callback then callback(input) end -- Pass the input to the callback
    end,
  })

  -- Enter insert mode automatically
  vim.api.nvim_set_current_win(win)
  vim.cmd("startinsert")
end

function M.confirm_input(buffer, win, callback)
  local input = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1]
  if input and input ~= "" then
    callback(input)
  end

  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
end


return M

