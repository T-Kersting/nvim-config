return {
    {
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
    },

    {
        "b0o/incline.nvim",
        config = function()
            local mocha = require("catppuccin.palettes").get_palette "mocha"
            local bgcolor = mocha.surface0
            local inactive_font_color = mocha.overlay0

            local signs = require("core.signs")

            local function get_diagnostic_label(props)
                local icons = {
                    Error = signs.error,
                    Warn = signs.warn,
                    Info = signs.info,
                    Hint = signs.hint,
                }

                local label = {}
                for severity, icon in pairs(icons) do
                    local n = #vim.diagnostic.get(props.buf, {
                        severity = vim.diagnostic.severity
                            [string.upper(severity)]
                    })
                    if n > 0 then
                        local fg = "#" ..
                            string.format("%06x",
                                vim.api.nvim_get_hl_by_name("DiagnosticSign" .. severity, true)["foreground"])
                        table.insert(label, { icon .. " " .. n .. " ", guifg = fg, guibg = bgcolor })
                    end
                end
                return label
            end

            require("incline").setup({
                debounce_threshold = { falling = 100, rising = 25 },
                render = function(props)
                    if props.focused and vim.api.nvim_win_get_cursor(props.win)[1] == 1 then
                        return {}
                    end

                    local bufname = vim.api.nvim_buf_get_name(props.buf)
                    local filename = vim.fn.fnamemodify(bufname, ":t")
                    local diagnostics = get_diagnostic_label(props)
                    local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "None"
                    local filetype_icon, color = require("nvim-web-devicons").get_icon_color(filename)

                    local filenamesettings = { filename, gui = modified, guibg = bgcolor }
                    if not props.focused then
                        filenamesettings["guifg"] = inactive_font_color
                    end

                    local buffer = {
                        { filetype_icon, guifg = color,  guibg = bgcolor },
                        { " ",           guibg = bgcolor },
                        filenamesettings,
                    }

                    if #diagnostics > 0 then
                        table.insert(diagnostics, { "| ", guifg = "grey", guibg = bgcolor })
                    end
                    for _, buffer_ in ipairs(buffer) do
                        table.insert(diagnostics, buffer_)
                    end

                    local signs = require("core.signs")
                    table.insert(diagnostics, 1, { signs.left, guifg = bgcolor })
                    table.insert(diagnostics, 2, { " ", guibg = bgcolor })
                    table.insert(diagnostics, { " ", guibg = bgcolor })
                    table.insert(diagnostics, { signs.right, guifg = bgcolor })

                    return diagnostics
                end,
            })
        end,
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
    },

    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local signs = require("core.signs")
            require('lualine').setup({
                options = {
                    theme = "catppuccin",
                    component_separators = '|',
                    section_separators = { left = signs.right, right = signs.left },
                    globalstatus = true
                },
                sections = {
                    lualine_a = {
                        { 'mode', separator = { left = signs.left }, right_padding = 2 },
                    },
                    lualine_b = { 'filename' },
                    lualine_c = {
                        'branch',
                        'diff',
                        {
                            'diagnostics',
                            symbols = {
                                error = signs.error .. " ",
                                warn = signs.warn .. " ",
                                info = signs.info .. " ",
                                hint = signs.hint .. " ",
                            }
                        }
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = {
                        { 'location', separator = { right = signs.right }, left_padding = 2 },
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
        'rcarriga/nvim-notify',
        config = function()
            local notify = require('notify')
            notify.setup {
                background_colour = "#000000",
                top_down = false,
            }
            vim.notify = notify
        end
    },

    {
        "petertriho/nvim-scrollbar",
        config = function()
            local scrollbar = require('scrollbar')
            scrollbar.setup()
        end
    }
}
