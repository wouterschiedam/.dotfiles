-- lua/plugin/vimgrep_replace/actions.lua
local M = {}
local ui = require("plugin.vimgrep_replace.ui")
local state = require("plugin.vimgrep_replace.state")

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

  local context = ui.create_split_in_single_buffer()
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

        ui.set_split_buffer_content(context, file, lnum, col, search_term, replace_with)
        return -- Show one replacement at a time
      end
    end
  end
end

return M

