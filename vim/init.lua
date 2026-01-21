local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

local function toggle_profile()
  local prof = require("profile")
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format("Wrote %s", filename))
      end
    end)
  else
    prof.start("*")
  end
end
vim.keymap.set("", "<f3>", toggle_profile)

require("stcursorword").setup()
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
vim.keymap.set({'n', 'x', 'o'}, 'gs', function ()
  require('leap.remote').action()
end)
vim.keymap.set({'x', 'o'}, 'R',  function ()
  require('leap.treesitter').select {
    opts = require('leap.user').with_traversal_keys('R', 'r')
  }
end)

require('leap').opts.preview = function (ch0, ch1, ch2)
  return not (
    ch1:match('%s')
    or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
  )
end

-- Define equivalence classes for brackets and quotes, in addition to
-- the default whitespace group:
require('leap').opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

-- Use the traversal keys to repeat the previous motion without
-- explicitly invoking Leap:
require('leap.user').set_repeat_keys('<enter>', '<backspace>')

-- Automatic paste after remote yank operations:
vim.api.nvim_create_autocmd('User', {
  pattern = 'RemoteOperationDone',
  group = vim.api.nvim_create_augroup('LeapRemote', {}),
  callback = function (event)
    if vim.v.operator == 'y' and event.data.register == '"' then
      vim.cmd('normal! p')
    end
  end,
})

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local lsp_status = require("lsp-status")

require("zk").setup()

local opts = { noremap = true, silent = false }

-- Create a new note after asking for its title.
vim.api.nvim_set_keymap("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)

-- Open notes.
vim.api.nvim_set_keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Open notes associated with the selected tags.
vim.api.nvim_set_keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)

-- Search for the notes matching a given query.
vim.api.nvim_set_keymap("n", "<leader>zf",
  "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", opts)
-- Search for the notes matching the current visual selection.
vim.api.nvim_set_keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", opts)

require('todo-comments').setup {}
require('dirbuf').setup {}
require('colorizer').setup()
require('gitsigns').setup()
require('trouble').setup()
require("statuscol").setup()

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = "if_many",
  },
  float = {
    source = "always",
    border = "rounded",
  },
  severity_sort = true,
})

require('whichkey_setup').config {}

require "octo".setup {}

local telescope_actions = require('telescope.actions')

-- Stop Telescope closing and staying in insert mode
vim.g.completion_chain_complete_list = {
  default = {
    { complete_items = { "lsp", "path", "buffers", "snippet" } },
    { mode = "<c-p>" },
    { mode = "<c-n>" },
  },
  TelescopePrompt = {},
  frecency = {},
}

local luasnip = require("luasnip")
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-CR>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  }
})

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = telescope_actions.move_selection_next,
        ["<C-k>"] = telescope_actions.move_selection_previous,
      },
    },
    file_ignore_patterns = { "^.git/" }
  },
  pickers = {
    find_files = {
      hidden = true
    },
    live_grep = {
      additional_args = function(opts)
        return { "--hidden" }
      end
    },
  },
}

require("inc_rename").setup()
vim.keymap.set("n", "<leader>in", ":IncRename ")

require('neoclip').setup()

local on_attach = function(client, bufnr)
  require "lsp_signature".on_attach({
    bind = true,
    floating_window = true,
    hint_prefix = {
      above = "↙ ",  -- when the hint is on the line above the current line
      current = "← ",  -- when the hint is on the same line
      below = "↖ "  -- when the hint is on the line below the current line
    },
    handler_opts = {
      border = "none"
    }
  }, bufnr)
  lsp_status.register_progress()
  lsp_status.config(
    {
      status_symbol = "LSP ",
      indicator_errors = "E",
      indicator_warnings = "W",
      indicator_info = "I",
      indicator_hint = "H",
      indicator_ok = "ok"
    }
  )

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<space>k", "<cmd>CodeActionMenu<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.server_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("crates").setup {
    lsp = {
        enabled = true,
        on_attach = on_attach,
        actions = true,
        completion = true,
        hover = true,
    },
}

default_opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float({ border = "single" })<CR>', default_opts)

vim.keymap.set('n', '<C-space>', '<Plug>RustHoverAction')
vim.keymap.set('n', '<Leader>ca', ':RustLsp codeAction')

vim.g.rustaceanvim = {
  tools = {},
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        check = {
          command = "clippy",
        },
        checkOnSave = true,
        procMacro = {
          enable = true,
        },
      },
    },
  },
  dap = {},
}

local lspconfig = require('lspconfig')
local servers = {
  "bashls",
  "html",
  "eslint",
  "graphql",
  "ts_ls",
  "lua_ls"
}

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    capabilities = capabilities
  })
end

local lsp_path = vim.env.NIL_PATH or 'nil'
vim.lsp.config('nil_ls', {
  autostart = true,
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { lsp_path },
  settings = {
    ['nil'] = {
      testSetting = 42,
    },
  },
})

vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  commands = {
    Format = {
      function()
        require("stylua-nvim").format_file()
      end,
    },
  },
})

vim.env.ELIXIR_ERL_OPTIONS = "+B -kernel prevent_overlapping_partitions false"
local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup({
  nextls = {
    enable = false, -- Deprecated, replaced by Expert
  },
  elixirls = {
    enable = true,
    cmd = "elixir-ls",
    on_attach = on_attach,
    capabilities = capabilities,
    settings = elixirls.settings({
      dialyzerEnabled = true,
      enableTestLenses = true,
      suggestSpecs = false,
    }),
  },
  projectionist = {
    enable = true,
  },
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = true
  }
)

require('rainbow-delimiters.setup').setup {}

require('treesitter-context').setup {
  enable = true,
  trim_scope = 'inner',
  multiline_threshold = 1
}

local harpoon = require('harpoon')
harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)

vim.keymap.set("n", "<C-S-e>", function() toggle_telescope(harpoon:list()) end,
  { desc = "Open harpoon window" })
