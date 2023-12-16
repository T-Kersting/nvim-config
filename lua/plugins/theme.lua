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
                    telescope = true,
                    notify = true,
                    mini = false,

                    harpoon = true,
                    leap = true,
                    which_key = true
                }
            })
            vim.cmd.colorscheme "catppuccin"
        end,
    }
}
