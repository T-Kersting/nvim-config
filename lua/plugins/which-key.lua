return {
    {
        "folke/which-key.nvim",
        dependencies = {
            { 'echasnovski/mini.icons', version = false },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 600
            local wk = require("which-key")
            wk.setup({
                preset = "modern"
            })

            wk.add {
                { "<leader>T", group = "[T]oggle" },
                { "<leader>W", group = "[W]orkspace" },
                { "<leader>c", group = "[c]ode" },
                { "<leader>g", group = "[g]it" },
                { "<leader>h", group = "Git [h]unk" },
                { "<leader>s", group = "[s]earch" },
                { "<leader>t", group = "File[t]ree" },
                { "<leader>w", group = "[w]indow" },
                -- { "<leader>x", group = "Trouble" },
            }

            -- register which-key VISUAL mode
            -- required for visual <leader>hs (hunk stage) to work
            wk.add({
                mode = { "v" },
                { "<leader>",  group = "VISUAL <leader>" },
                { "<leader>h", desc = "Git [H]unk" },
            }, { mode = 'v' })
        end
    }
}
