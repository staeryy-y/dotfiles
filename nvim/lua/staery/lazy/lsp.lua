return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "pyright", "ts_ls", "html", "cssls" },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
          })
        end,
      },
    })

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, {})
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, {})
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, {})
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, {})
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, {})
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {})
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, {})
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, {})
  end,
}
