local mocha = require("catppuccin.palettes").get_palette "mocha"

vim.api.nvim_set_hl(
    0,
    "CopilotSuggestion",
    { italic = true, fg = mocha.overlay0, underline = true }
)
