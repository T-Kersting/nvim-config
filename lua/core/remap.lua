vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--vim.keymap.set("n", "<leader>pp", vim.cmd.Ex, { desc = "Open netrw" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('t', "<Esc>", "<C-\\><C-n>", { desc = "Terminal: Return to normal mode" })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', '<down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--[[ vim.keymap.set('i', '<up>', "v:count == 0 ? '<c-\\><c-o>gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('i', '<down>', "v:count == 0 ? '<c-\\><c-o>gj' : 'j'", { expr = true, silent = true }) ]]

vim.keymap.set("n", "<M-left>", ":tabprevious<CR>", { desc = "Goto previous tab" })
vim.keymap.set("n", "<M-right>", ":tabnext<CR>", { desc = "Goto next tab" })
vim.keymap.set("n", "<M-up>", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<M-down>", ":tabclose<CR>", { desc = "Close tab" })

--vim.keymap.set("n", "<C-left>", ":wincmd h<CR>", { desc = "Goto left window" })
--vim.keymap.set("n", "<C-down>", ":wincmd j<CR>", { desc = "Goto bottom window" })
--vim.keymap.set("n", "<C-up>", ":wincmd k<CR>", { desc = "Goto top window" })
--vim.keymap.set("n", "<C-right>", ":wincmd l<CR>", { desc = "Goto right window" })

vim.keymap.set("v", "<S-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection one line down" })
vim.keymap.set("v", "<S-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection one line up" })

-- keep cursor in same spot after using 'J'
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor in middle with half page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "delete into void register, [p]aste" })

vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "[y]ank into clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "[Y]ank line into clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "[d]elete into void register" })

-- Tmux navigator
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set("n", "<C-left>", ":<C-U>TmuxNavigateLeft<cr>", { desc = "Goto left window" })
vim.keymap.set("n", "<C-down>", ":<C-U>TmuxNavigateDown<cr>", { desc = "Goto bottom window" })
vim.keymap.set("n", "<C-up>", ":<C-U>TmuxNavigateUp<cr>", { desc = "Goto top window" })
vim.keymap.set("n", "<C-right>", ":<C-U>TmuxNavigateRight<cr>", { desc = "Goto right window" })
vim.keymap.set("n", "<C-/>", ":<C-U>TmuxNavigatePrevious<cr>", { desc = "Goto previous window" })

vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "[v]ertical split" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "[h]orizontal split" })
vim.keymap.set("n", "<leader>wc", ":close<CR>", { desc = "[c]lose window" })
vim.keymap.set("n", "<leader>wo", ":only<CR>", { desc = "Close [o]ther windows" })
vim.keymap.set("n", "<leader>ws", ":wincmd x<CR>", { desc = "[s]wap windows" })

--vim.keymap.set("n", "<leader>fp", ":silent %!npx prettier --stdin-filepath %<CR>", { desc = "Format file with prettier" })

vim.keymap.set("n", "<leader>Tw", ":set wrap!<CR>", { desc = "[T]oggle line [w]rap" })
