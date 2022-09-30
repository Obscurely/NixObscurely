local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- lspservers with default config
local servers = {
  "html",
  "cssls",
  "clangd",
  "sumneko_lua",
  "tsserver",
  "csharp_ls",
  "java_language_server",
  "pyright",
  "bashls",
  "remark_ls",
  "gopls",
  "jsonls",
  "taplo",
  "cmake",
  "yamlls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Arduino language server config
lspconfig["arduino_language_server"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "arduino-language-server",
    "-cli-config", ".arduino15/arduino-cli.yaml",
    "-fqbn", "arduino:avr:uno",
    "-cli", "arduino-cli",
    "-clangd", "clangd"
  }
}
