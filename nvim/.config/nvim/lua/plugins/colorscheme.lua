return {
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
