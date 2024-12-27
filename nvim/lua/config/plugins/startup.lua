return {
    "startup-nvim/startup.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("startup").setup({
            header = {
                type = "text",
                align = "center",
                fold_section = false,
                title = "Welcome to Neovim",
                margin = 5,
                content = {
                    " ███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗",
                    " ████╗  ██║██╔════╝██║   ██║██║████╗ ████║",
                    " ██╔██╗ ██║███████╗██║   ██║██║██╔████╔██║",
                    " ██║╚██╗██║╚════██║██║   ██║██║██║╚██╔╝██║",
                    " ██║ ╚████║███████║╚██████╔╝██║██║ ╚═╝ ██║",
                    " ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝╚═╝     ╚═╝",
                },
                highlight = "Statement",
            },
            body = {
                type = "mapping",
                align = "center",
                fold_section = false,
                title = "Quick Access",
                margin = 5,
                content = {
                    { " Find File", "Telescope find_files", "<leader>ff" },
                    { " Recent Files", "lua require'config.utils.startup_util'.recent_files_from_current_dir()", "<leader>rf" },
                    { " New File", "lua require'startup'.new_file()", "<leader>nf" },
                    { " Load Session", "SessionLoad", "<leader>sl" },
                },
                highlight = "String",
            },
            footer = {
                type = "text",
                align = "center",
                fold_section = false,
                margin = 5,
                content = { "🎉 Happy Coding!" },
                highlight = "Comment",
            },
            options = {
                disable_statuslines = true,
                paddings = { 2, 2, 2, 2 },
            },
            parts = { "header", "body", "footer" },
        })
    end
}

