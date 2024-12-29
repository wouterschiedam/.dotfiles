-- lua/plugin/vimgrep_replace/init.lua
local M = {}
local keymaps = require("plugin.vimgrep_replace.keymaps")

function M.setup(opts)
  opts = opts or {}
  local state = require("plugin.vimgrep_replace.state")
  state.set_options(opts.options or {})
  keymaps.setup_global_keymaps(opts)
end

return M
