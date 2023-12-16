return {
    {
        "ThePrimeagen/harpoon",
        keys = {
            { "<M-s>", nil, desc = "Harpoon: Set Mark"},
            { "<M-t>", nil, desc = "Harpoon: Toggle Quick Menu"},
            { "<M-n>", nil, desc = "Harpoon: Navigate to File 1"},
            { "<M-e>", nil, desc = "Harpoon: Navigate to File 2"},
            { "<M-i>", nil, desc = "Harpoon: Navigate to File 3"},
            { "<M-o>", nil, desc = "Harpoon: Navigate to File 4"},
        },
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<M-s>", mark.add_file)
            vim.keymap.set("n", "<M-t>", ui.toggle_quick_menu)

            vim.keymap.set("n", "<M-n>", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<M-e>", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<M-i>", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<M-o>", function() ui.nav_file(4) end)
        end
    }
}
