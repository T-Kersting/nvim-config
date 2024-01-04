return {
    -- highlight the word under the cursor
    { "RRethy/vim-illuminate" },
    --[[ {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local api = require("nvim-tree.api")
            local on_attach = function(bufnr)
                local function opts(desc)
                    return {
                        desc = desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true
                    }
                end

                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.del("n", "<C-V>", { buffer = bufnr })
                vim.keymap.del("n", "<C-x>", { buffer = bufnr })

                vim.keymap.set("n", "<leader>v", api.node.open.vertical, opts("Open: Vertical Split"))
                vim.keymap.set("n", "<leader>h", api.node.open.horizontal, opts("Open: Horizontal Split"))
            end

            require("nvim-tree").setup {
                on_attach = on_attach,
                actions = {
                    open_file = {
                        quit_on_open = true,
                    }
                },
                diagnostics = {
                    enable = true,
                },
                --                view = {
                --                    centralize_selection = true,
                --                    side = "right",
                --                    preserve_window_proportions = true,
                --                    float = {
                --                        enable = true,
                --                        quit_on_focus_loss = true,
                --                        open_win_config = {
                --                            row = 0,
                --                            width = 30,
                --                            border = "rounded",
                --                            relative = "editor",
                --                            col = vim.o.columns,
                --                            height = vim.o.lines - 4,
                --                            title = "nvim-tree"
                --                        },
                --                    }
                --                }
            }

            local find_and_focus = function()
                api.tree.find_file()
                api.tree.focus()
            end

            vim.keymap.set("n", "<leader>tt", api.tree.focus, { desc = "Focus NvimTree" })
            vim.keymap.set("n", "<leader>tf", find_and_focus, { desc = "Find file in NvimTree" })
            vim.keymap.set("n", "<leader>to", api.tree.open, { desc = "Open NvimTree" })
            vim.keymap.set("n", "<leader>tc", api.tree.close, { desc = "Close NvimTree" })
            vim.keymap.set("n", "<leader>tr", api.tree.reload, { desc = "Refresh NvimTree" })
            vim.keymap.set("n", "<leader>tl", api.tree.collapse_all, { desc = "Collapse NvimTree" })
        end
    }, ]]

    {
        "b0o/incline.nvim",
        config = function()
            local signs = require("core.signs")
            local mocha = require("catppuccin.palettes").get_palette "mocha"

            local inactive_font_color = mocha.overlay0
            local active_font_color = mocha.subtext1

            -- helper function to create diagnostic label
            local function insert_diagnostic_label(props, render_items)
                local icons = {
                    Error = signs.error,
                    Warn = signs.warn,
                    Info = signs.info,
                    Hint = signs.hint,
                }

                for severity, icon in pairs(icons) do
                    local n = #vim.diagnostic.get(
                        props.buf,
                        {
                            severity = vim.diagnostic.severity
                                [string.upper(severity)]
                        }
                    )
                    if n > 0 then
                        local fg = "#" ..
                            string.format(
                                "%06x",
                                vim.api.nvim_get_hl_by_name("DiagnosticSign" .. severity, true)["foreground"]
                            )
                        table.insert(render_items, { icon .. n .. " ", guifg = fg })
                    end
                end
                return render_items
            end

            require("incline").setup({
                debounce_threshold = { falling = 100, rising = 25 },
                render = function(props)
                    -- Hide incline when cursor is in first row
                    if props.focused and vim.api.nvim_win_get_cursor(props.win)[1] == 1 then
                        return {}
                    end

                    local buffer_name = vim.api.nvim_buf_get_name(props.buf)
                    local filename = vim.fn.fnamemodify(buffer_name, ":t")
                    local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "None"
                    local font_color = props.focused and active_font_color or inactive_font_color
                    local filetype_icon, icon_color = require("nvim-web-devicons").get_icon_color(filename)

                    local render_items = {
                        { "󰄽 ", guifg = font_color },
                    }

                    render_items = insert_diagnostic_label(props, render_items)
                    if #render_items > 1 then
                        table.insert(render_items, { "| ", guifg = font_color })
                    end

                    table.insert(render_items, { filetype_icon, guifg = icon_color })
                    table.insert(render_items, { " " .. filename, guifg = font_color, gui = modified })
                    table.insert(render_items, { " 󰄾", guifg = font_color })

                    return render_items
                end,
            })
        end,
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        opts = {
            indent = {
                char = "┊"
            },
            scope = {
                show_start = false,
                show_end = false,
                char = "│"
            }
        },
    },

    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local signs = require("core.signs")
            require('lualine').setup({
                options = {
                    theme = "catppuccin",
                    --[[ component_separators = '|',
                    section_separators = { left = signs.right, right = signs.left }, ]]
                    globalstatus = true
                },
                sections = {
                    lualine_a = {
                        { 'mode' },
                    },
                    lualine_b = { 'filename' },
                    lualine_c = {
                        'branch',
                        'diff',
                        {
                            'diagnostics',
                            symbols = {
                                error = signs.error,
                                warn = signs.warn,
                                info = signs.info,
                                hint = signs.hint,
                            }
                        }
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = {
                        { 'location' },
                    },
                },
                inactive_sections = {
                    lualine_a = { 'filename' },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { 'location' },
                },
                tabline = {},
                extensions = {},
            })
        end
    },

    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
                override_vim_notify = true,
            }
        }
    },

    {
        "petertriho/nvim-scrollbar",
        dependencies = {
            'lewis6991/gitsigns.nvim',
        },
        opts = {
            handlers = {
                gitsigns = true
            }
        }
    }
}
