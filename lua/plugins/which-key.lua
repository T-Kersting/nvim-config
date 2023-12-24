return {
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 600
            local wk = require("which-key")
            wk.setup({
                window = {
                    border = "single"
                }
            })

            wk.register {
                ['<leader>c'] = { name = '[c]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[d]ocument', _ = 'which_key_ignore' },
                ['<leader>g'] = { name = '[g]it', _ = 'which_key_ignore' },
                ['<leader>h'] = { name = 'Git [h]unk', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[r]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[t]oggle', _ = 'which_key_ignore' },
                ['<leader>k'] = { name = 'Wor[k]space', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[w]indow', _ = 'which_key_ignore' },
            }
        end
    }
}
