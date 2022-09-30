local M = {}

M.navigation = {
  i = {
    ["<C-l>"] = {"<End>"},
    ["<C-e>"] = {"<Right>"}
  }
}

M.misc = {
  i = {
    ["<C-s>"] = {"<cmd> :w <CR>"} -- ctrl s in insert mode to save
  },
  n = {
    ["<leader>cc"] = {":Telescope <CR>"},
    ["<leader>q"] = {":q <CR>"},
    ["<leader>s"] = {":set spell!<CR>"}, -- activate deactivate spelling
    ["<leader>fr"] = {":Format<CR>"}, -- Format when hitting leader + f + r
    ["<leader><leader>"] = {":Alpha<CR>"}, -- Open Alpha (dashboard)
    ["<leader>d"] = {":TroubleToggle<CR>"}, -- trouble key bind (diagnostics)
    ["<leader>a"] = {":SymbolsOutline<CR>"}
  }
}

return M
