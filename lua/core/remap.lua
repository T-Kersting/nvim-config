vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--vim.keymap.set("n", "<leader>pp", vim.cmd.Ex, { desc = "Open netrw" })

vim.keymap.set('t', "<Esc>", "<C-\\><C-n>", { desc = "Terminal: Return to normal mode" })

vim.keymap.set("n", "<M-left>", ":tabprevious<CR>", { desc = "Goto previous tab" })
vim.keymap.set("n", "<M-right>", ":tabnext<CR>", { desc = "Goto next tab" })
vim.keymap.set("n", "<M-up>", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<M-down>", ":tabclose<CR>", { desc = "Close tab" })

--vim.keymap.set("n", "<C-left>", ":wincmd h<CR>", { desc = "Goto left window" })
--vim.keymap.set("n", "<C-down>", ":wincmd j<CR>", { desc = "Goto bottom window" })
--vim.keymap.set("n", "<C-up>", ":wincmd k<CR>", { desc = "Goto top window" })
--vim.keymap.set("n", "<C-right>", ":wincmd l<CR>", { desc = "Goto right window" })

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

vim.keymap.set("n", "<leader>tl", ":set wrap!<CR>", { desc = "[t]oggle [l]ine wrap" })
