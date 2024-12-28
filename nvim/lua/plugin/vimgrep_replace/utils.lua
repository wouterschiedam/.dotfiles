local M = {}

function M.set_buffer_options(buf, options)
  for option, value in pairs(options) do
    vim.api.nvim_buf_set_option(buf, option, value)
  end
end

function M.set_window_options(win, options)
  for option, value in pairs(options) do
    vim.api.nvim_win_set_option(win, option, value)
  end
end

function M.setup_floating_window(buf, win_config, buf_options, win_options)
  local win = vim.api.nvim_open_win(buf, true, win_config)
  M.set_buffer_options(buf, buf_options)
  M.set_window_options(win, vim.tbl_extend("force", {}, win_options or {}))
  return win
end


return M
