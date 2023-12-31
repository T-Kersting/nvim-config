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
                ['<leader>g'] = { name = '[g]it', _ = 'which_key_ignore' },
                ['<leader>h'] = { name = 'Git [h]unk', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[s]earch', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[t]ree', _ = 'which_key_ignore' },
                ['<leader>T'] = { name = '[T]oggle', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[w]indow', _ = 'which_key_ignore' },
                ['<leader>W'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            }

            -- register which-key VISUAL mode
            -- required for visual <leader>hs (hunk stage) to work
            wk.register({
                ['<leader>'] = { name = 'VISUAL <leader>' },
                ['<leader>h'] = { 'Git [H]unk' },
            }, { mode = 'v' })
        end
    }
}
