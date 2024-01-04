return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = {
            popup_border_style = 'rounded',
            window = {
                mappings = {
                    ['<tab>'] = function(state)
                        local node = state.tree:get_node()
                        if require("neo-tree.utils").is_expandable(node) then
                            state.commands["toggle_node"](state)
                        else
                            state.commands['open'](state)
                            vim.cmd('Neotree reveal')
                        end
                    end,
                }
            }
        },
        keys = {
            { "<leader>tt", ":Neotree toggle focus<cr>",     desc = "[t]oggle Tree" },
            { "<leader>tf", ":Neotree focus<cr>",            desc = "[f]ocus Tree" },
            { "<leader>tr", ":Neotree reveal focus<cr>",     desc = "[r]eveal current file in Tree" },
            { "<leader>tc", ":Neotree close<cr>",            desc = "[c]lose Tree" },
            { "<leader>ts", ":Neotree show<cr>",             desc = "[s]how Tree" },
            { "<leader>tg", ":Neotree git_status focus<cr>", desc = "[g]it status" },
            { "<leader>tb", ":Neotree buffers focus<cr>",    desc = "open [b]uffers" },
        }
    },
}
