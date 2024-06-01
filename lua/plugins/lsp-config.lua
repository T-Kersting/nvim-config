local border_type = "single"

return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            ui = {
                border = border_type
            }
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
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
                nmap('<leader>r', vim.lsp.buf.rename, '[r]ename')
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

            local mason_registry = require('mason-registry')
            local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
                '/node_modules/@vue/language-server'
            local capabilities = require("cmp_nvim_lsp").default_capabilities();
            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    if server_name == "tailwindcss" then
                        lspconfig.tailwindcss.setup {
                            settings = {
                                tailwindCSS = {
                                    experimental = {
                                        classRegex = { { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" } }
                                    }
                                }
                            }
                        }
                    elseif server_name == "tsserver" then
                        lspconfig.tsserver.setup {
                            init_options = {
                                plugins = {
                                    {
                                        name = '@vue/typescript-plugin',
                                        location = vue_language_server_path,
                                        languages = { 'vue' },
                                    },
                                },
                            },
                            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
                            on_attach = on_attach,
                            capabilities = capabilities,
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
        end
    },
    "folke/neodev.nvim",
}
