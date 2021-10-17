local conf = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = (function()
                local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                table.sort(res)
                return res
            end)()
        }
    }
}

capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  vim.cmd("au! CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()")
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = {silent = false, noremap = true}

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  buf_set_keymap('n', 'gh',         '<Cmd>lua vim.lsp.buf.hover()<CR>',                        opts)
  buf_set_keymap('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',               opts)
  buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                   opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                       opts)
  buf_set_keymap('n', '<Leader>cl', '<Cmd>lua vim.lsp.codelens.run()<CR>',                     opts)
  buf_set_keymap('n', '<Leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',             opts)
  buf_set_keymap('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',             opts)
  buf_set_keymap('n', '<Leader>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',           opts)
  require('config.telescope').lsp_bindings_for_buffer(bufnr)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    vim.cmd("au! BufWritePre <buffer> lua vim.lsp.buf.formatting()")
  end

  require "lsp_signature".on_attach()
end


local function lua_settings()
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      }
    }
end

local function make_config()
  return {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      }
    }
end

local function typescript_on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  on_attach(client, bufnr)
end


function conf.setup()
  local lsp_status = require('lsp-status')
  lsp_status.register_progress()

  require'lspinstall'.setup()

  -- get all installed servers
  local servers = require'lspinstall'.installed_servers()

  local nvim_lsp = require('lspconfig')

  for _, lsp in ipairs(servers) do
    local config = make_config()
    if lsp == "lua" then
      config.settings = lua_settings()
    elseif lsp == "typescript" then
      config.on_attach = typescript_on_attach
    end
    nvim_lsp[lsp].setup(config)
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = true,
      underline = true,
      update_in_insert = false,
      virtual_text = true,
    }
  )
end

require'lspinstall'.post_install_hook = function ()
  conf.setup() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

return conf
