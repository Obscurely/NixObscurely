local autosave = require "auto-save"

local M = {}

M.setup = function()
  autosave.setup {
    enabled = true
  }
end

return M
