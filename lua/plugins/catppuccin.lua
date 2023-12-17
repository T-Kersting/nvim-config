return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = {
                        enabled = true,
                    },
                    mini = false,
                    indent_blankline = {
                        enabled = true,
                        scope_color = "sky",
                        colored_indent_levels = false,
                    },

                    mason = true,
                    harpoon = true,
                    leap = true,
                    which_key = true
                }
            })
            vim.cmd.colorscheme "catppuccin"
        end,
    }
}
