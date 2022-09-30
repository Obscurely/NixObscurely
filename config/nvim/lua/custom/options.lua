local opt = vim.opt
local g = vim.g

-- vim.opt options
opt.backup = false -- creates a backup file
opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
opt.completeopt = {"menuone", "noselect"}
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
-- opt.foldmethod = "expr" -- folding set to "expr" for treesitter based folding
-- opt.foldexpr = "nvim_treesitter#foldexpr()" -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
opt.hidden = true -- required to keep multiple buffers and open multiple buffers
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 2 -- always show tabs
opt.smartcase = true -- smart case
opt.smartindent = true -- make indenting smarter again
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.swapfile = false -- creates a swapfile
opt.termguicolors = true -- set term gui colors (most terminals support this)
opt.title = true -- set the title of window to the value of the titlestring
opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set termguicolors
opt.undofile = true -- enable persistent undo
opt.updatetime = 300 -- faster completion
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited
opt.expandtab = false -- forces the use of tabs
opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
opt.tabstop = 4 -- insert 2 spaces for a tab
opt.cursorline = true -- highlight the current line
opt.number = true -- set numbered lines\
opt.relativenumber = false -- set relative numbered lines
opt.numberwidth = 2 -- set number column width to 2 {default 4}
opt.signcolumn = "yes" -- always show the sign column otherwise it would shift the text each time
opt.wrap = true -- continue displaying long lines by going on the next line, wrapping as the name suggests.
opt.spell = false
opt.spelllang = "en"
opt.scrolloff = 8
opt.sidescrolloff = 8

-- vim.g options
g.did_load_filetypes = 1 -- disable default loadtypes plugins thing in order to use the new filetypes.nvim one
