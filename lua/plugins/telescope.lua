return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope: Find Files" })
        vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "Telescope: Git Files" })
        vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = "Telescope: Live Grep" })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Telescope: Help Tags" })
    end
}
