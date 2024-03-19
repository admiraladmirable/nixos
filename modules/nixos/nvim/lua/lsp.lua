local keymaps = require("keymaps")

local nvim_lsp_status_ok, lspconfig = pcall(require, "lspconfig")
if not nvim_lsp_status_ok then
    return
end

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

local prettier_status_ok, prettier = pcall(require, "prettier")
if not prettier_status_ok then
    return
end

local on_attach = keymaps.lsp_maps(_,bufnr)

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local language_servers = {
    'gopls',
    'clangd',
    'tsserver',
    'cmake',
    'jsonls',
    'cssls',
    'html',
    'tsserver',
}

local null_ls_servers = {
    --NixOs
    diagnostics.deadnix,
    formatting.alejandra, -- Not implemented ATM
    code_actions.statix, --Currently not working
    --Lua
    formatting.stylua, -- Not implemented ATM
    --Typescript
    formatting.prettier,
    --Golang
    formatting.gofumpt,
    formatting.goimports,
    code_actions.gomodifytags,
    --diagnostics.staticcheck,
    --C++
    diagnostics.checkmake,
    --diagnostics.cmake_lint,
    --diagnostics.cppcheck,
    --diagnostics.cpplint,
    --Misc
    diagnostics.shellcheck,
    diagnostics.yamllint, -- Yaml Linter
    diagnostics.hadolint, -- Docker Linter
    diagnostics.dotenv_linter, -- .env Linter
    diagnostics.vint, -- Vimscript Linter
    diagnostics.ansiblelint, -- Ansible Linter
    diagnostics.jsonlint, -- Json Linter

}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = capabilities,
        on_attach = on_attach
    })
end

for _, nls in ipairs(null_ls_servers) do
    null_ls.register({nls})
end

require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            version = 'LuaJIT'
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

require('go').setup()

lspconfig.eslint.setup({
  --- ...
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})


local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>q", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})


prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})
