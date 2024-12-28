-- lua/plugin/vimgrep_replace/actions.lua
local M = {}

local ui = require("plugin.vimgrep_replace.ui")
local state = require("plugin.vimgrep_replace.state")
local keymaps = require("plugin.vimgrep_replace.keymaps")

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

  local quickfix_list = vim.fn.getqflist()

  if vim.tbl_isempty(quickfix_list) then
    print("Quickfix is empty!")
    return
  end

  local context = ui.create_split_in_single_buffer(keymaps.mappings)

  for i = #quickfix_list, 1, -1 do
    local entry = quickfix_list[i]
    local file = entry.bufnr and vim.fn.bufname(entry.bufnr) or entry.filename

    if file and file ~= "" then
      local lnum = entry.lnum
      local col = entry.col
      local bufnr = vim.fn.bufadd(file) -- Add the file to the buffer list
      vim.fn.bufload(bufnr) -- Load the buffer content into memory without opening it

      -- Get the specific line from the buffer
      local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
      if #lines > 0 then
        local current_line = lines[1]
        local updated_line = current_line:sub(1, col - 1) .. replace_with .. current_line:sub(col + #search_term)

        -- Update the line in the buffer
        vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { updated_line })

        -- Show the change in the split buffer for preview
        ui.set_split_buffer_content(context, file, lnum, col, search_term, replace_with)

        -- Save the buffer to persist changes to disk
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("write")
        end)

        return -- Show one replacement at a time
      end
    end
  end
end

return M
