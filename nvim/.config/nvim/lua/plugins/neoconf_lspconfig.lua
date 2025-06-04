return {
  { "folke/neoconf.nvim" },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
  },
}
