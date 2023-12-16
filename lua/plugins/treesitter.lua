return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "rust",
                    "javascript",
                    "typescript",
                    "css",
                    "html",
                    "php",
                    "vue"
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                }
            }
        end
    }
}
