return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  lazy = false,
  branch = "main",
  opts = {
    settings = {
      search = {
        anaconda_base = {
          command = "fd /python$ /opt/anaconda/bin --full-path --color never -E /proc",
          type = "anaconda",
        },
      },
    },
  },
}
