return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}

      local function open_explorer(dir)
        local explorer = Snacks.picker.get({ source = "explorer" })[1]
        if explorer then
          explorer:close()
        end
        vim.defer_fn(function()
          Snacks.explorer({ cwd = dir })
        end, explorer and 80 or 0)
      end

      local function open_project(dir)
        dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":p")
        if vim.fn.isdirectory(dir) == 0 then
          vim.notify(("Project not found: %s"):format(dir), vim.log.levels.WARN)
          return
        end
        vim.cmd("tcd " .. vim.fn.fnameescape(dir))
        open_explorer(dir)
      end

      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = vim.tbl_deep_extend("force", opts.picker.sources.explorer or {}, {
        -- Show dotfiles in the file explorer by default, but keep ignored files hidden.
        hidden = true,
      })
      opts.picker.sources.files = vim.tbl_deep_extend("force", opts.picker.sources.files or {}, {
        -- Start Find Files in the result list so j/k and arrows work immediately.
        focus = "list",
      })
      opts.picker.sources.projects = vim.tbl_deep_extend("force", opts.picker.sources.projects or {}, {
        -- Start Projects in the result list so j/k and arrows work immediately.
        focus = "list",
        -- Scan the main workspace and include a few manually pinned projects.
        dev = { "~/allgemeiner-intellekt" },
        projects = {
          "~/.config/nvim",
          "~/.pi",
          "~/.agents",
        },
        recent = false,
        confirm = function(picker, item)
          picker:close()
          if item then
            open_project(item.file)
          end
        end,
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
        { icon = " ", title = "Recent Projects", section = "projects", limit = 6, padding = 1, action = open_project },
        { section = "startup" },
      }

      return opts
    end,
  },
}
