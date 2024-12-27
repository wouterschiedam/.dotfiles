return {
  {
    "hkupty/iron.nvim",
    config = function()
      require('iron.core').setup {
        config = {
          repl_definition = {
            python = {
              command = { "ipython" },
            },
          },
          repl_open_cmd = 'vertical botright split',
        },
        keymaps = {
          send_motion = "<leader>rs",                 -- REPL send selected motion
          visual_send = "<leader>rv",                 -- REPL send visual selection
          send_file = "<leader>rf",                   -- REPL send the entire file
          send_line = "<leader>rl",                   -- REPL send the current line
          send_paragraph = "<leader>rp",              -- REPL send the current paragraph
          send_until_cursor = "<leader>ru",           -- REPL send until cursor
          send_mark = "<leader>rm",                   -- REPL send a marked region
          mark_motion = "<leader>mm",                 -- Mark a motion
          mark_visual = "<leader>mv",                 -- Mark a visual selection
          remove_mark = "<leader>md",                 -- Remove the mark
          cr = "<leader>rr",                          -- Execute the current REPL command
          interrupt = "<leader>ri",                   -- Interrupt the current REPL execution
          exit = "<leader>rq",                        -- Exit the REPL
          clear = "<leader>rc",                       -- Clear the REPL buffer
        },
        highlight = {
          italic = true,
        },
      }
    end,
  },
}
