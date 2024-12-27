local M = {}

function M.recent_files_from_current_dir()
    local cwd = vim.fn.getcwd() -- Get the current working directory
    require('telescope.builtin').oldfiles({
        cwd_only = true,         -- Restrict to current directory
        cwd = cwd,               -- Set the working directory for the picker
    })
end

return M
