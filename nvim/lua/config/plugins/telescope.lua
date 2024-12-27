return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.3",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")

            -- Key mappings
            vim.keymap.set("n", "<leader>vm", builtin.help_tags, { desc = "Show Help Tags" })
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
            vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find Git Files" })
            vim.keymap.set("n", "<leader>lg", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end, { desc = "Live Grep with Input" })
        end,
    },
}

