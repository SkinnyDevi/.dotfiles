local rose_pine_theme = {
  -- Add Rose Pine colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    styles = {
      transparency = true,
    },
  },

  -- Load lazyvim with Rose Pine
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}

local pywal_color_theme = {
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    config = function()
      require("neopywal").setup({
        use_wallust = false,
        transparent = true,
        term_colors = true,
      })

      vim.cmd.colorscheme("neopywal")
    end,
  },
}

return pywal_color_theme
