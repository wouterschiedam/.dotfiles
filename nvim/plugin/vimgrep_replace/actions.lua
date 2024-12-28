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
  state.set_current_index(current_index + 1)
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

return M
