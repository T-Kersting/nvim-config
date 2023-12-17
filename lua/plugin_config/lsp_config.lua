require("mason").setup({
    ui = {
        border = "single",
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "volar",
        --"tsserver",
        "rust_analyzer",
    }
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true;

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities();
cmp_capabilities.textDocument.completion.dynamicRegistration = true;

capabilities = vim.tbl_extend("force", capabilities, cmp_capabilities)

local on_attach = function(client, _)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover" })

    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: Go to Next Diagnostic" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: Go to Previous Diagnostic" })

    vim.keymap.set("n", "<leader>dn", vim.lsp.buf.rename, { desc = "LSP: Rename" })
    vim.keymap.set("n", "<leader>da", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "LSP: Open Diagnostic" })
    vim.keymap.set("n", "<leader>di", vim.lsp.buf.implementation, { desc = "LSP: Go to Implementation" })
    vim.keymap.set("n", "<leader>dr", vim.lsp.buf.references, { desc = "LSP: Show References" })
    vim.keymap.set("n", "<leader>dt", vim.lsp.buf.type_definition, { desc = "LSP: Go to Type Definition" })
    vim.keymap.set("n", "<leader>de", require('telescope.builtin').diagnostics, { desc = "LSP: Get all Diagnostics" })

    if client.name == "eslint" then
        vim.keymap.set("n", "<leader>df", ":EslintFixAll<cr>", { desc = "LSP: Format", remap = true })
    else
        vim.keymap.set("n", "<leader>df", vim.lsp.buf.format, { desc = "LSP: Format" })
    end
end

require("neodev").setup({})

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
    function(server_name)
        if server_name == "volar" then
            lspconfig.volar.setup {
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
                settings = {
                    vue = {
                        complete = {
                            casing = {
                                tags = "autoKebab"
                            }
                        }
                    }
                }
            }
        elseif server_name == 'eslint' then
            lspconfig.eslint.setup {
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "EslintFixAll"
                    })
                end,
                capabilities = capabilities,
            }
        else
            lspconfig[server_name].setup {
                on_attach = on_attach,
                capabilities = capabilities,
            }
        end
    end,
})

-- use telescope for lsp
local telescope_builtin = require("telescope.builtin")
vim.lsp.handlers["textDocument/definition"] = telescope_builtin.lsp_definitions;
vim.lsp.handlers["textDocument/references"] = telescope_builtin.lsp_references;
vim.lsp.handlers["textDocument/typeDefinition"] = telescope_builtin.lsp_type_definitions;

-- TODO: Add in own file
-- add border around LSP Info
require("lspconfig.ui.windows").default_options.border = "single"

-- add border around LSP Hover
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single",
        -- add the title in hover float window
        title = "hover"
    }
)

-- add border around LSP SignatureHelp
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single"
    }
)

vim.diagnostic.config({
    float = { border = "single" }
})


-- Autoformatting
-- Taken from kickstart-nvim

-- Switch for controlling whether you want autoformatting.
--  Use :KickstartFormatToggle to toggle autoformatting on or off
local format_is_enabled = true
vim.api.nvim_create_user_command('KickstartFormatToggle', function()
    format_is_enabled = not format_is_enabled
    print("Setting autoformatting to: " .. tostring(format_is_enabled))
end, {})

-- Create an augroup that is used for managing our formatting autocmds.
--      We need one augroup per client to make sure that multiple clients
--      can attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
    if not _augroups[client.id] then
        local group_name = 'kickstart-lsp-format-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
    end

    return _augroups[client.id]
end

-- Whenever an LSP attaches to a buffer, we will run this function.
--
-- See `:help LspAttach` for more information about this autocmd event.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),

    -- This is where we attach the autoformatting for reasonable clients.
    callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        -- Only attach to clients that support document formatting
        if not client.server_capabilities.documentFormattingProvider then
            return
        end

        -- Tsserver usually works poorly. Sorry you work with bad languages
        -- You can remove this line if you know what you're doing :)
        if client.name == 'tsserver' then
            return
        end

        if client.name == 'volar' then
            return
        end

        -- Create an autocmd that will run *before* we save the buffer.
        -- Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
                if not format_is_enabled then
                    return
                end

                vim.lsp.buf.format {
                    async = false,
                    filter = function(c)
                        return c.id == client.id
                    end
                }
            end
        })
    end
})
