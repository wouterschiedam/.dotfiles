return {
  {
    "tpope/vim-fugitive",
    config = function()
      -- Key mappings for Fugitive commands
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Git Status" })
      vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git Diff" })
    end,
  },
}
