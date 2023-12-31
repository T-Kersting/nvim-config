return {
    -- TODO: Test
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local tdc = require("todo-comments")
        tdc.setup()

        vim.keymap.set("n", "]t", function()
            tdc.jump_next()
        end, { desc = "Next todo comment" })

        vim.keymap.set("n", "[t", function()
            tdc.jump_prev()
        end, { desc = "Previous todo comment" })

        vim.keymap.set("n", "<leader>xt", ":TodoTrouble<CR>", { desc = "[t]odo comments" })
    end,
}
