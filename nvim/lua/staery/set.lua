vim.cmd.colorscheme("tokyonight")

-- system clipboard: yank/delete/paste go to the OS clipboard, not just vim's registers
vim.opt.clipboard = "unnamedplus"

-- mouse support in all modes (normal, visual, insert, command)
vim.opt.mouse = "a"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
