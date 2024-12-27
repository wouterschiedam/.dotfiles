local set = vim.opt;

set.guicursor = ""

set.nu = true
set.relativenumber = true

-- Default tab settings (fallback if .editorconfig isn't applied)
set.tabstop = 2
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true

set.smartindent = true

set.wrap = false

set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

set.hlsearch = false
set.incsearch = true

set.termguicolors = true

set.scrolloff = 8
set.signcolumn = "yes"
set.isfname:append("@-@")

set.updatetime = 50

-- set.colorcolumn = "150"
set.formatoptions = vim.o.formatoptions:gsub('cro', '') -- Avoid comments to continue on new lines

