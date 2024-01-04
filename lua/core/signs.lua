local signs = {
    error = " ",
    warn = " ",
    info = " ",
    hint = "󰌵",

    left = "",
    right = "",
}

vim.fn.sign_define("DiagnosticSignError",
    { text = signs.error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
    { text = signs.warn, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
    { text = signs.info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
    { text = signs.hint, texthl = "DiagnosticSignHint" })

return signs
