return {
    {
        "numToStr/FTerm.nvim",
        opts = {
            border = 'single',
            dimensions = {
                height = 0.9,
                width = 0.9,
            }
        },
        keys = {
            {
                "<A-f>",
                mode = { "n", "t" },
                function()
                    require("FTerm").toggle()
                end,
                desc = "FTerm"
            },
        },
    }
}
