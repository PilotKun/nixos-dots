vim.o.background = "dark"
require("gruvbox").setup({
    contrast = "hard", -- Available options: "hard", "soft" or "" (empty string)
})
vim.cmd.colorscheme("gruvbox")
vim.cmd("hi Directory guibg=NONE")
vim.cmd("hi SignColumn guibg=NONE")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })