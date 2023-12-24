return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup {}

        -- Enable telescope fzf native, if installed
        pcall(require('telescope').load_extension, 'fzf')
        local builtin = require("telescope.builtin")
        local themes = require("telescope.themes")

        local function find_git_root()
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir
            local cwd = vim.fn.getcwd()

            if current_file == '' then
                current_dir = cwd
            else
                current_dir = vim.fn.fnamemodify(current_file, ':h')
            end

            -- Find the Git root directory from the current file's path
            local cmd = 'git -C ' .. vim.fn.escape(current_dir, ' ') .. " rev-parse --show-toplevel"
            local git_root = vim.fn.systemlist(cmd)[1]
            if vim.v.shell_error ~= 0 then
                print 'Not a git repository. Searching on current working directory'
                return cwd
            end
            return git_root
        end

        -- Custom live_grep function to search in git root
        local function live_grep_git_root()
            local git_root = find_git_root()
            if git_root then
                builtin.live_grep {
                    search_dirs = { git_root }
                }
            end
        end

        local function current_buffer_fuzzy_search()
            builtin.current_buffer_fuzzy_find(themes.get_dropdown {
                winblend = 0,
                previewer = false,
            })
        end

        local function telescope_live_grep_open_files()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end

        -- Create command
        vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

        vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = "[?] Find recently opened files" })
        vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing Buffers' })
        vim.keymap.set('n', '<leader>/', current_buffer_fuzzy_search, { desc = '[/] Fuzzily search in current buffer' })
        vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[s]earch in [/] in Open Files' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]earch [s]elect Telescope' })
        vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [g]it [f]iles' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[s]earch [f]iles' })
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch by [G]rep on Git Root' })
        vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[s]earch by [g]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
    end
}
