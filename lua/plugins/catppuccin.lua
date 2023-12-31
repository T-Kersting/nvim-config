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
                    fidget = true,
                    flash = true,
                    gitsigns = true,
                    harpoon = true,
                    indent_blankline = {
                        enabled = true,
                        scope_color = "sky",
                        colored_indent_levels = false,
                    },
                    leap = true,
                    mason = true,
                    nvimtree = true,
                    telescope = {
                        enabled = true,
                    },
                    lsp_trouble = true,
                    which_key = true
                }
            })
            vim.cmd.colorscheme "catppuccin"
        end,
    }
}
