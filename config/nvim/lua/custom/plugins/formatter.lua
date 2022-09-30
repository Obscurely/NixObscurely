local formatter = require "formatter"

local file_types = {
  javascript = {
    -- prettier
    function()
      return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
        stdin = true
      }
    end
  },
  rust = {
    -- Rustfmt
    function()
      return {
        exe = "rustfmt",
        args = {"--emit=stdout", "--edition=2021"},
        stdin = true
      }
    end
  },
  json = {
    function()
      return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--double-quote"},
        stdin = true
      }
    end
  },
  sh = {
    -- Shell Script Formatter
    function()
      return {
        exe = "shfmt",
        args = {"-i", 2},
        stdin = true
      }
    end
  },
  lua = {
    -- luafmt
    function()
      return {
        exe = "luafmt",
        args = {"--indent-count", 2, "--stdin"},
        stdin = true
      }
    end
  },
  cpp = {
    -- clang-format
    function()
      return {
        exe = "clang-format",
        args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
        stdin = true,
        cwd = vim.fn.expand("%:p:h") -- Run clang-format in cwd of the file.
      }
    end
  },
  python = {
    -- Configuration for psf/black
    function()
      return {
        exe = "black", -- this should be available on your $PATH
        args = {"-"},
        stdin = true
      }
    end
  },
  go = {
    function()
      return {
        exe = "gofmt",
        stdin = true
      }
    end
  },
  html = {
    function()
      return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
        stdin = true;
      }
    end
  },
  css = {
    function()
      return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
        stdin = true;
      }
    end
  }
}

local M = {}

M.setup = function()
  formatter.setup {
    filetype = file_types
  }
end

return M
