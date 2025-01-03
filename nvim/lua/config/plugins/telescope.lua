local function custom_get_ivy(opts)
  opts = opts or {}

  local theme_opts = {
    theme = "ivy",

    layout_strategy = "bottom_pane",
    layout_config = {
      height = 50,
    },

    vimgrep_arguments = {
        "rg",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--ignore",
        "--hidden", -- Include hidden files
        "--glob", "!**/node_modules/*", -- Exclude 'node_modules' folder
        "--glob", "!**/.git/*", -- Exclude '.git' folder
        "--glob", "!**/vendor/*",-- Exclude vendor
        "--glob", "!**/public/js/*/*", -- Exclude all subfolders inside 'public/js'
        "--glob", "!**/public/css/*/*", -- Exclude all subfolders inside 'public/css'
    },

    border = true,
    borderchars = {
      prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
      results = { " " },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
  }
  if opts.layout_config and opts.layout_config.prompt_position == "bottom" then
    theme_opts.borderchars = {
      prompt = { " ", " ", "─", " ", " ", " ", "─", "─" },
      results = { "─", " ", " ", " ", "─", "─", " ", " " },
      preview = { "─", " ", "─", "│", "┬", "─", "─", "╰" },
    }
  end

  return vim.tbl_deep_extend("force", theme_opts, opts)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.3",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")

      require("telescope").setup({
        defaults = custom_get_ivy(),
      })

      -- Key mappings
      vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)
      vim.keymap.set("n", "<leader>vm", builtin.help_tags, { desc = "Show Help Tags" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Find Git Files" })
      vim.keymap.set("n", "<leader>lg", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "Live Grep with Input" })
    end,
  },
}

