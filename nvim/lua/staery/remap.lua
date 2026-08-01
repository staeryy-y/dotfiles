vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- file explorer
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- symbol outline
vim.keymap.set("n", "<leader>o", ":SymbolsOutline<CR>")

-- paste over a visual selection without overwriting the clipboard/register
vim.keymap.set({ "n", "v" }, "<leader>p", [["_dP]])

-- search and replace word under cursor, project-wide via :s
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
