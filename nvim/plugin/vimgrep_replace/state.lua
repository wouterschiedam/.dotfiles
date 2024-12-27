-- lua/plugin/vimgrep_replace/state.lua
local M = {}

local state = {
  search_term = nil,
}

function M.set_search_term(term)
  state.search_term = term
end

function M.get_search_term()
  return state.search_term
end

return M

