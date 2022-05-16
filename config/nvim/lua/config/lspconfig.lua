local conf = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

capabilities.textDocument.codeAction = {
  dynamicRegistration = true,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = (function()
        local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
        table.sort(res)
        return res
      end)(),
    },
  },
}

capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
function conf.lightbulb()
  require("nvim-lightbulb").update_lightbulb({
    sign = {
      enabled = false,
    },
    float = {
      enabled = true,
      text = "💡",
    },
  })
end

local common_on_attach = function(client, bufnr)
  -- capabilities
  -- {messages
  --   call_hierarchy = false,
  --   code_action = {
  --     codeActionKinds = { "", "quickfix", "refactor.rewrite", "refactor.extract" },
  --     resolveProvider = false
  --   },
  --   code_lens = false,
  --   code_lens_resolve = false,
  --   completion = true,
  --   declaration = false,
  --   document_formatting = false,
  --   document_highlight = true,
  --   document_range_formatting = false,
  --   document_symbol = true,
  --   execute_command = true,
  --   find_references = true,
  --   goto_definition = true,
  --   hover = true,
  --   implementation = false,
  --   rename = true,
  --   signature_help = true,
  --   signature_help_trigger_characters = { "(", "," },
  --   text_document_did_change = 2,
  --   text_document_open_close = true,
  --   text_document_save = false,
  --   text_document_save_include_text = false,
  --   text_document_will_save = false,
  --   text_document_will_save_wait_until = false,
  --   type_definition = true,
  --   workspace_folder_properties = {
  --     changeNotifications = false,
  --     supported = false
  --   },
  --   workspace_symbol = true
  -- }
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
  )
  vim.cmd("au! CursorHold,CursorHoldI <buffer> lua require('config.lspconfig').lightbulb()")
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  local opts = { silent = false, noremap = true, buffer = bufnr }

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
  require("config.telescope").lsp_bindings_for_buffer(bufnr)

  if client.resolved_capabilities.hover then
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
  end
  if client.resolved_capabilities.rename then
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
  end
  if client.resolved_capabilities.code_lens then
    vim.keymap.set("n", "<Leader>cl", vim.lsp.codelens.run, opts)
    vim.cmd("au! BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()")
  end
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<leader>gq", vim.lsp.buf.formatting, opts)
    vim.cmd("au! BufWritePre <buffer> lua vim.lsp.buf.formatting()")
  end

  require("lsp_signature").on_attach({
    bind = true,
    zindex = 40,
    transparency = 40,
    auto_close_after = 4,
    max_width = 60,
    handler_opts = {
      border = "rounded", -- double, rounded, single, shadow, none
    },
  })
end

local function lua_settings()
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
    Lua = {
      format = {
        enable = false,
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  }
end

local function make_config()
  return {
    on_attach = common_on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

local function typescript_on_attach(client, bufnr)
  client.resolved_capabilities.document_formatting = false
  common_on_attach(client, bufnr)
end

local function eslint(config)
  config.on_attach = function(client, bufnr)
    print("attached")
    client.resolved_capabilities.document_formatting = true
    common_on_attach(client, bufnr)
  end
  config.settings = {
    format = { enable = true }, -- this will enable formatting
  }
  config.handlers = {
    ["eslint/probeFailed"] = function()
      vim.notify("ESLint probe failed.", vim.log.levels.WARN)
      --return { id = nil, result = true }
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
      -- return { id = nil, result = true }
    end,
  }
  config.cmd = vim.list_extend({ "yarn", "node" }, config.cmd)
  return config
end

local function elixir(config)
  config.root_dir = require("lspconfig.util").root_pattern(".git")
  config.on_init = function(client)
    client.notify("workspace/didChangeConfiguration")
    return true
  end
  return config
end

local function lua(config)
  config.settings = lua_settings()
  config.on_attach = function(client, bufnr)
    common_on_attach(client, bufnr)
  end
  return config
end

function conf.setup()
  vim.diagnostic.config({ header = false, float = { border = "rounded" }, signs = false })

  local lsp_status = require("lsp-status")
  lsp_status.register_progress()

  local lsp_installer = require("nvim-lsp-installer")

  local servers = { "sumneko_lua", "rust_analyzer", "elixirls", "jsonls", "tsserver", "yamlls" }

  require("nvim-lsp-installer").setup({
    ensure_installed = servers,
  })

  for _, server in ipairs(servers) do
    local config = make_config()
    config.capabilities = vim.tbl_extend("keep", config.capabilities, lsp_status.capabilities)

    local ok, lsp_server = require("nvim-lsp-installer").get_server(server)
    if server == "sumneko_lua" then
      config = lua(config)
    elseif server == "typescript" then
      config.on_attach = typescript_on_attach
    elseif server == "elixirls" then
      config = elixir(config)
    elseif server == "eslint" then
      config = eslint(config)
    end

    require("lspconfig")[server].setup(config)
  end

  -- server:setup(config)
  -- end)

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = true,
  })
end

return conf
