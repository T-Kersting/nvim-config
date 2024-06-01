return {
    --[[ "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local t = require("trouble")
        t.setup()

        local nmap = function(keys, func, desc)
            if desc then
                desc = 'Trouble: ' .. desc
            end
            vim.keymap.set('n', keys, func, { desc = desc })
        end

        nmap("<leader>xx", function() t.toggle() end, "Toggle List")
        nmap("<leader>xw", function() t.toggle("workspace_diagnostics") end, "[w]orkspace Diagnostics")
        nmap("<leader>xd", function() t.toggle("document_diagnostics") end, "[d]ocument Diagnostics")
        nmap("<leader>xq", function() t.toggle("quickfix") end, "[q]uickfix")
        nmap("<leader>xl", function() t.toggle("loclist") end, "[l]ocation List")
        nmap("gR", function() t.toggle("lsp_references") end, "LSP [R]eferences")

        local trouble = require("trouble.sources.telescope")

        local telescope = require("telescope")

        telescope.setup {
            defaults = {
                mappings = {
                    i = { ["<c-t>"] = trouble.open },
                    n = { ["<c-t>"] = trouble.open },
                },
            },
        }
    end, ]]
}
