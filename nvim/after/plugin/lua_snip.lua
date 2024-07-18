local ls = require("luasnip")

-- Key mappings for expanding and navigating snippets.
vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump(1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
  if ls.choice_active() then
      ls.change_choice(1)
  end
end, {silent = true})

-- load your custom snippets
local snippets_ok, my_snippets = pcall(require, "wouter.snippets")
    if not snippets_ok then
    print("Error loading snippets")
    return
end

ls.add_snippets("php", my_snippets.php)
