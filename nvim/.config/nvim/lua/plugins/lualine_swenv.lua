local function python_env()
  return "WIP" or "No venv selected" -- Name of venv or empty if no venv
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      function()
        if vim.bo.filetype == "python" then
          return "🐍" .. python_env()
        end

        return ""
      end,
    })
  end,
}
