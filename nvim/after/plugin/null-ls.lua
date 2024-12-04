local null_ls = require("null-ls")
local util = require("null-ls.utils")

local get_phpcs_config = function(params)
    local project_root = util.root_pattern("phpcs.xml")(params.bufname)
    if project_root then
        return project_root .. "/phpcs.xml"
    else
        return nil
    end
end

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.phpcbf.with({
            command = "/opt/homebrew/bin/phpcbf",
            args = function(params)
                local phpcs_config = get_phpcs_config(params)
                if phpcs_config then
                    return { "--standard=" .. phpcs_config, params.filename }
                else
                    return { "--standard=PSR12", params.filename }
                end
            end,
            filetypes = { "php" },
        }),
        null_ls.builtins.diagnostics.phpcs.with({
            command = "/opt/homebrew/bin/phpcs",
            args = function(params)
                local phpcs_config = get_phpcs_config(params)
                return {
                    "--standard=" .. (phpcs_config or "PSR12"),
                    "--report=json",
                    "--stdin-path=" .. params.bufname,
                    params.bufname,
                }
            end,
            on_output = function(params)
                local diagnostics = {}
                if not params.output or not params.output.files then
                    return diagnostics
                end

                local file_diagnostics = params.output.files[params.bufname] or params.output.files["STDIN"]
                if not file_diagnostics or not file_diagnostics.messages then
                    return diagnostics
                end

                for _, message in ipairs(file_diagnostics.messages) do
                    table.insert(diagnostics, {
                        row = message.line,
                        col = message.column,
                        message = message.message,
                        severity = message.type == "ERROR" and 1 or 2,
                        source = message.source,
                    })
                end
                return diagnostics
            end,
        }),
    },
})

