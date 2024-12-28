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
          fg = '#ffffff',
          bg = '#808080',
        },
        replace = {
          fg = '#ffffff',
          bg = '#FF0000',
        },
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

function M.set_highlight_group(opts)
    state.highlight_group.search = opts.search
    state.highlight_group.replace = opts.replace
end

function M.get_highlight_group()
    if not state.highlight_group.search or not state.highlight_group.replace then
        -- Set default highlight groups if not defined
        vim.api.nvim_set_hl(0, 'Search', { fg = "#ffffff", bg = "#808080" })
        vim.api.nvim_set_hl(0, 'Replace', { fg = "#ffffff", bg = "#FF0000" })

        state.highlight_group.search = 'Search'
        state.highlight_group.replace = 'Replace'
    end
    return state.highlight_group
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
  state.options = vim.tbl_deep_extend("force", state.options, opts or {})
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

