-- lua/plugin/vimgrep_replace/init.lua
-- -- test
local M = {}
local keymaps = require("plugin.vimgrep_replace.keymaps")

function M.setup(opts)
  opts = opts or {}
  local state = require("plugin.vimgrep_replace.state")
  state.set_options(opts.options or {})
  keymaps.setup_global_keymaps(opts)
end

return M

-- Setup
-- {
--    keymaps = {
--      global = {
--        vimgrep = '<leader>vg',
--        replace = '<leader>qr',
--      },
--      buffer = {
--        accept = 'l',
--        decline = 'h',
--        cancel = 'q',
--        skip = 'n',
--      }
--    },
--    highlight_group = {
--      search = {
--        fg = '#ffffff',
--        bg = '#808080',
--      },
--      replace = {
--        fg = '#ffffff',
--        bg = '#FF0000',
--      }
--    }
-- }

