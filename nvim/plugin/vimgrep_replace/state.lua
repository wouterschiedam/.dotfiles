-- lua/plugin/vimgrep_replace/state.lua
local M = {}

local state = {
  search_term = nil,
  highlight_group = {},
}

function M.set_search_term(term)
  state.search_term = term
end

function M.set_highlight_group(opts)
  state.highlight_group.search = opts.search
  state.highlight_group.replace = opts.replace
end

function M.get_search_term()
  return state.search_term
end

function M.get_highlight_group()
  if not state.highlight_group then
    -- Set default highlight groups if not defined
    vim.api.nvim_set_hl(0, 'Search', { fg = "#ffffff", undercurl = true })
    vim.api.nvim_set_hl(0, 'replace', { fg = "#0077FF", undercurl = true })

    state.highlight_group = {
      search = 'Search',
      replace = 'Replace',
    }
  end
  return state.highlight_group
end

return M

