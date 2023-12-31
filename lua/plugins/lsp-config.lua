local border_type = "single"

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = {
            ui = {
                border = border_type
            }
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = {
            ensure_installed = {
                "lua_ls",
            }
        }
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local telescope_builtin = require('telescope.builtin')
            local on_attach = function(_, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                -- Keybinds
                --  Info
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                --  Navigation
                nmap(']d', vim.diagnostic.goto_next, 'Goto next Diagnostic')
                nmap('[d', vim.diagnostic.goto_prev, 'Goto previous Diagnostic')

                nmap('gd', telescope_builtin.lsp_definitions, '[g]oto [d]efinition')
                nmap('gr', telescope_builtin.lsp_references, '[g]oto [r]eferences')
                nmap('gI', telescope_builtin.lsp_implementations, '[g]oto [I]mplementations')

                nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration]')

                --  Code
                nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')
                nmap('<leader>ct', telescope_builtin.lsp_type_definitions, '[t]ype definition')
                nmap('<leader>cs', telescope_builtin.lsp_document_symbols, 'Document [s]ymbols')
                nmap('<leader>cd', vim.diagnostic.open_float, 'Hover [d]iagnostic Info')
                nmap('<leader>cf', vim.lsp.buf.format, '[f]ormat current buffer with LSP')

                -- Workspace keybinds
                nmap('<leader>Ws', telescope_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [s]ymbols')
                nmap('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [a]dd Folder')
                nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [r]emove Folder')
                nmap('<leader>Wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [l]ist Folders')

                -- Commands
                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })
            end

            -- TODO: is this working? keyword "didChangeWatchedFiles"
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true;

            local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities();
            cmp_capabilities.textDocument.completion.dynamicRegistration = true;

            capabilities = vim.tbl_extend("force", capabilities, cmp_capabilities)

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
                                vim.keymap.set("n", "<leader>cf", ":EslintFixAll<cr>",
                                    { desc = "LSP: Format with Eslint", remap = true })
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

            -- set lsp handlers to use telescope
            vim.lsp.handlers["textDocument/definition"] = telescope_builtin.lsp_definitions;
            vim.lsp.handlers["textDocument/references"] = telescope_builtin.lsp_references;
            vim.lsp.handlers["textDocument/typeDefinition"] = telescope_builtin.lsp_type_definitions;

            -- add border around LSP Info
            require("lspconfig.ui.windows").default_options.border = border_type

            -- add border around LSP Hover
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
                vim.lsp.handlers.hover, {
                    -- Use a sharp border with `FloatBorder` highlights
                    border = border_type,
                    -- add the title in hover float window
                    title = "Hover"
                }
            )

            -- add border around LSP SignatureHelp
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
                vim.lsp.handlers.signature_help, {
                    -- Use a sharp border with `FloatBorder` highlights
                    border = border_type
                }
            )

            vim.diagnostic.config({
                float = { border = border_type }
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
        end
    },
    "folke/neodev.nvim",
}
