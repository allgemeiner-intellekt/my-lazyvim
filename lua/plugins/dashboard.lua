return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            -- Show dotfiles in the file explorer by default, but keep ignored files hidden.
            hidden = true,
          },
        },
      },
      dashboard = {
        preset = {
          header = "",
        },
      },
    },
  },
}
