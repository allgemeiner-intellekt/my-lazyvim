return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}

      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer or {}, {
        -- Show dotfiles in the file explorer by default, but keep ignored files hidden.
        hidden = true,
      })
      opts.picker.sources.projects = vim.tbl_deep_extend("force", opts.picker.sources.projects or {}, {
        -- Scan the main workspace and include a few manually pinned projects.
        dev = { "~/allgemeiner-intellekt" },
        projects = {
          "~/.config/nvim",
          "~/.pi",
        },
        recent = false,
      })

      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = ""
      opts.dashboard.preset.keys = {
        { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      }
      opts.dashboard.sections = {
        { section = "keys", gap = 1, padding = 1 },
        -- Show the 6 recent projects on the dashboard.
        { icon = " ", title = "Recent Projects", section = "projects", limit = 6, padding = 1 },
        { section = "startup" },
      }

      return opts
    end,
  },
}
