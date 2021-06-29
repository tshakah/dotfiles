local lspconfig = require "lspconfig"
local lsp_status = require("lsp-status")
local configs = require'lspconfig/configs'

-- function to attach completion when setting up lsp
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

local on_attach = function(client)
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
    local opts = {noremap = true, silent = true}
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            " autocmd CursorHold *.* :lua vim.lsp.diagnostic.show_line_diagnostics()
            autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 300)
           augroup END
        ]],
            false
        )
    else
        -- autocmd BufWritePre * Neoformat
        vim.api.nvim_exec([[
            autocmd!
            augroup END
        ]], false)
    end
end

vim.lsp.handlers['textDocument/hover'] = function(_, method, result)
  vim.lsp.util.focusable_float(method, function()
    if not (result and result.contents) then
      -- return { 'No information available' }
      return
    end
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      -- return { 'No information available' }
      return
    end
    local bufnr, winnr = vim.lsp.util.fancy_floating_markdown(markdown_lines, {
      pad_left = 1; pad_right = 1;
    })
    vim.lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden"}, winnr)
    return bufnr, winnr
  end)
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {
    "bashls",
    "rust_analyzer",
    "phpactor",
    "elixirls"
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = lsp_status.capabilities
    }
end

--if not lspconfig.psalmls then
--  configs.psalmls = {
--    default_config = {
--      cmd = {"php", "-d memory_limit=2G", "/home/elishahastings/.config/composer/vendor/bin/psalm-language-server"};
--      filetypes = {'php'};
--      root_dir = function(fname)
--        return lspconfig.util.find_git_ancestor(fname) or lspconfig.util.root_pattern("psalm.xml")
--      end;
--      settings = {};
--    };
--  }
--end

lspconfig.elixirls.setup {
    cmd = {'elixir-ls'}
}

--lspconfig.psalmls.setup {}
lspconfig.phpactor.setup {
    cmd = {'/home/elishahastings/.config/composer/vendor/bin/phpactor', 'language-server'}
}

-- Setup diagnostics formaters and linters for non LSP provided files
lspconfig.diagnosticls.setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
    cmd = {"diagnostic-languageserver", "--stdio"},
    filetypes = {
        "lua",
        "sh",
        "markdown",
        "json",
        "yaml",
        "toml",
        "php",
        "elixir",
        "eelixir"
    },
    init_options = {
        linters = {
            psalm = {
                command = "~/.config/composer/vendor/bin/psalm",
                debounce = 100,
                rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
                args = {"--output-format=emacs", "--no-progress"},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "psalm",
                formatLines = 1,
                formatPattern = {
                    "^[^:]+:(\\d):(\\d):(.*)\\s-\\s(.*)(\\r|\\n)*$",
                    {
                        line = 1,
                        column = 2,
                        message = 4,
                        security = 3
                    }
                },
                securities = {
                    error = "error",
                    warning = "warning"
                },
                requiredFiles = {"psalm.xml"}
            },
            phpstan = {
                command = "phpstan",
                debounce = 100,
                rootPatterns = {"composer.json", "composer.lock", "vendor", ".git"},
                args = {"analyze", "--error-format", "raw", "--no-progress", "%file"},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "phpstan",
                formatLines = 1,
                formatPattern = {
                    "^[^:]+:(\\d+):(.*)(\\r|\\n)*$",
                    {
                        line = 1,
                        message = 2
                    }
                }
            },
            shellcheck = {
                command = "shellcheck",
                debounce = 100,
                args = {"--format", "json", "-"},
                sourceName = "shellcheck",
                parseJson = {
                    line = "line",
                    column = "column",
                    endLine = "endLine",
                    endColumn = "endColumn",
                    message = "${message} [${code}]",
                    security = "level"
                },
                securities = {
                    error = "error",
                    warning = "warning",
                    info = "info",
                    style = "hint"
                }
            },
            mix_credo = {
                command = "mix",
                debounce = 100,
                rootPatterns = {"mix.exs"},
                args = {"credo", "suggest", "--format", "flycheck", "--read-from-stdin"},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "mix_credo",
                formatLines = 1,
                formatPattern = {
                    "^[^ ]+?:([0-9]+)(:([0-9]+))?:\\s+([^ ]+):\\s+(.*)$",
                    {
                        line = 1,
                        column = 3,
                        message = 5,
                        security = 4
                    }
                },
                securities = {
                    F = "warning",
                    C = "warning",
                    D = "info",
                    R = "info"
                }
            },
            markdownlint = {
                command = "markdownlint",
                isStderr = true,
                debounce = 100,
                args = {"--stdin"},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "markdownlint",
                formatLines = 1,
                formatPattern = {
                    "^.*?:\\s?(\\d+)(:(\\d+)?)?\\s(MD\\d{3}\\/[A-Za-z0-9-/]+)\\s(.*)$",
                    {
                        line = 1,
                        column = 3,
                        message = {4}
                    }
                }
            }
        },
        filetypes = {
            php = {"phpstan", "psalm"},
            sh = "shellcheck",
            markdown = "markdownlint",
            elixir = "mix_credo",
            eelixir = "mix_credo"
        },
        formatters = {
            shfmt = {
                command = "shfmt",
                args = {"-i", "2", "-bn", "-ci", "-sr"}
            },
            prettier = {
                command = "prettier",
                args = {"--stdin-filepath", "%filepath"},
            },
            mix_format = {
                command = "mix",
                args = {"format"}
            }
        },
        formatFiletypes = {
            sh = "shfmt",
            json = "prettier",
            yaml = "prettier",
            toml = "prettier",
            markdown = "prettier",
            lua = "prettier",
            elixir = "mix_format",
            eelixir = "mix_format"
        }
    }
}

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        underline = true,
        virtual_text = false,
        signs = true,
        update_in_insert = true
    }
)

-- Set up treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
}
