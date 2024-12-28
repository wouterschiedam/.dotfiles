-- lua/plugin/vimgrep_replace/init.lua
-- testtesttest
local M = {}
local keymaps = require("plugin.vimgrep_replace.keymaps")

function M.setup(opts)
  opts = opts or {}

  keymaps.setup_global_keymaps(opts)
end

M.setup()


