local dap = require('dap')
local ui = require('dapui')

require('dapui').setup()

dap.adapters.php = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" }
}

dap.configurations.php = {
    {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
        pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}"
        },
        log = true,
        xdebugSettings = {
            max_children= 256,
            max_data= 1024,
            max_depth= 5
        }
    }
}

vim.fn.sign_define('DapBreakpoint', { text='⚑', texthl='Breakpoint', numhl='Breakpoint' })

vim.keymap.set('n', '<F1>', function() dap.continue() end)
vim.keymap.set('n', '<F2>', function() dap.step_over() end)
vim.keymap.set('n', '<F3>', function() dap.step_into() end)
vim.keymap.set('n', '<F4>', function() dap.step_out() end)
vim.keymap.set('n', '<F5>', function() dap.step_back() end)
vim.keymap.set('n', '<F6>', function() dap.run_last() end)
vim.keymap.set('n', '<F7>', function() dap.disconnect({ terminateDebuggee = true }) end)

vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)


vim.keymap.set({'n', 'v'}, '<Leader>du', function()
    ui.open()
end)

vim.keymap.set({'n', 'v'}, '<Leader>dc', function()
    ui.close()
end)


vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)

vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end)
