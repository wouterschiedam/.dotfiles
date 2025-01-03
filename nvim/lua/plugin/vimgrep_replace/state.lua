-- lua/plugin/vimgrep_replace/state.lua
local M = {}

local state = {
  directory = nil,
  search_term = nil,
  replacement = nil,
  highlight_group = {},
  context = nil,  -- Stores the UI context for floating windows
  current_index = 1, -- Tracks the current quickfix entry being processed
  options = { -- Default options can be overwritten
    excluded_dir = {},
    keymaps = {
      toggle = "<Tab>",
      global = {
        vimgrep = '<leader>vg',
        replace = '<leader>qr',
      },
      buffer = {
        accept = 'l',
        decline = 'h',
        cancel = 'q',
        skip = 'n',
      },
    },
    highlight_group = {
      search = {
        fg = '#C0CAF5',
        bg = '#3B4261',
      },
      replace = {
        fg = '#F7768E',
        bg = '#2A2F4A',
      },
      win = {
        leftwin = {
          guifg = "#7AA2F7",
        },
        rightwin = {
          guifg = "#9ECE6A",
        },
        global = {
          guifg = "#FF9E64",
        },
      }
    },
  },
  buffers = {}
}

function M.get_excluded_dir()
  return state.options.excluded_dir
end

function M.set_dir(dir)
  state.directory = dir
end

function M.get_dir()
  return state.directory
end

function M.set_search_term(term)
  state.search_term = term
end

function M.get_search_term()
  return state.search_term
end

function M.set_replacement(replace)
  state.replacement = replace
end

function M.get_replacement()
  return state.replacement
end

function M.set_highlight_group()
  -- Fetch colors from options or use defaults
  local search_colors = M.get_options().highlight_group.search
  local replace_colors = M.get_options().highlight_group.replace

  -- Set the Search highlight group
  vim.api.nvim_set_hl(0, 'vgSearchText', { fg = search_colors.fg, bg = search_colors.bg })

  -- Set the Replace highlight group
  vim.api.nvim_set_hl(0, 'vgReplaceText', { fg = replace_colors.fg, bg = replace_colors.bg })

end

function M.get_highlight_group()
  return {
    search = 'vgSearchText',
    replace = 'vgReplaceText',
  }
end

function M.set_context(new_context)
  state.context = new_context
end

function M.get_context()
  return state.context
end

function M.set_current_index(index)
  state.current_index = index
end

function M.get_current_index()
  return state.current_index
end

function M.set_options(opts)
  -- Merge new options into defaults without overwriting unspecified keys
  state.options = vim.tbl_deep_extend("keep", opts or {}, state.options)
end

function M.get_options()
  return state.options
end

function M.set_buffers(opts)
  state.buffers = opts or {}
end

function M.get_buffers()
  return state.buffers
end
return M

