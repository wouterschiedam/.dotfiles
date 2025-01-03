-- lua/plugin/vimgrep_replace/init.lua
local M = {}
local keymaps = require("plugin.vimgrep_replace.keymaps")

function M.setup(opts)
  opts = opts or {}
  local state = require("plugin.vimgrep_replace.state")
  local utils = require("plugin.vimgrep_replace.utils")

  for group, option in pairs(state.get_options().highlight_group.win) do
    utils.set_highlight_groups(group, option)
  end
  state.set_highlight_group()


  state.set_options(opts.options or {})
  keymaps.setup_global_keymaps(opts)
end

return M
