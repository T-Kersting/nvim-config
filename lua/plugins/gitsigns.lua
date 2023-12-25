return {
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            numhl = true,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                local function my_next_hunk()
                    -- return default in diff views
                    if vim.wo.diff then
                        return ']c'
                    end

                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end

                local function my_prev_hunk()
                    if vim.wo.diff then
                        return '[c'
                    end

                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end

                -- Navigation
                map({ 'n', 'v' }, ']c', my_next_hunk, { expr = true, desc = "Jump to next hunk" })
                map({ 'n', 'v' }, '[c', my_prev_hunk, { expr = true, desc = "Jump to previous hunk" })

                -- Actions
                -- visual mode
                map('v', '<leader>hs', function()
                    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = '[s]tage git hunk' })
                map('v', '<leader>hr', function()
                    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = '[r]evert git hunk' })

                -- normal mode
                map('n', '<leader>hs', gs.stage_hunk, { desc = 'git [s]tage hunk' })
                map('n', '<leader>hr', gs.reset_hunk, { desc = 'git [r]eset hunk' })
                map('n', '<leader>hS', gs.stage_buffer, { desc = 'git [S]tage buffer' })
                map('n', '<leader>hR', gs.reset_buffer, { desc = 'git [R]eset buffer' })
                map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[u]ndo stage hunk' })
                map('n', '<leader>hp', gs.preview_hunk, { desc = '[p]review git hunk' })
                map('n', '<leader>hb', function()
                    gs.blame_line { full = false }
                end, { desc = 'git [b]lame line' })
                map('n', '<leader>hd', gs.diffthis, { desc = 'git [d]iff against index' })
                map('n', '<leader>hD', function()
                    gs.diffthis '~'
                end, { desc = 'git [D]iff against last commit' })

                -- Toggles
                map('n', '<leader>Tb', gs.toggle_current_line_blame, { desc = '[T]oggle git [b]lame line' })
                map('n', '<leader>Td', gs.toggle_deleted, { desc = '[T]oggle git show [d]eleted' })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
            end,
        }
    }
}
