local M = {}

-- nvim treesitter configuration (default plugin)
M.treesitter = {
  ensure_installed = {
    "lua",
    "html",
    "css",
    "javascript",
    "cpp",
    "c_sharp",
    "java",
    "python",
    "rust",
    "bash",
    "markdown",
    "go",
    "json",
    "toml",
    "make",
    "regex",
    "yaml",
    "nix",
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  autotag = {
    enable = true
  }
}

return M
