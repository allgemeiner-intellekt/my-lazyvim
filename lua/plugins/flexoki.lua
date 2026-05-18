return {
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    init = function()
      local cursor_colors = {
        normal = "#dc8a78",
        insert = "#40a02b",
        select = "#7287fd",
      }

      vim.opt.guicursor = table.concat({
        "n-c-o-sm:block-CursorNormal",
        "i-ci:block-CursorInsert",
        "v-ve:block-CursorSelect",
        "r-cr:hor20-CursorInsert",
        "t:block-CursorInsert",
      }, ",")

      local function set_terminal_cursor_color(color)
        -- OSC 12 sets the terminal cursor color. This is needed in Warp,
        -- where guicursor highlight groups may not be applied visually.
        vim.api.nvim_chan_send(vim.v.stderr, "\027]12;" .. color .. "\007")
      end

      local function sync_cursor_color()
        local mode = vim.api.nvim_get_mode().mode
        local first = mode:sub(1, 1)

        if mode == "v" or mode == "V" or mode == "\022" or first == "s" then
          set_terminal_cursor_color(cursor_colors.select)
        elseif first == "i" or first == "r" or first == "R" or mode == "t" then
          set_terminal_cursor_color(cursor_colors.insert)
        else
          set_terminal_cursor_color(cursor_colors.normal)
        end
      end

      vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged", "FocusGained" }, {
        callback = sync_cursor_color,
      })

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          -- OSC 112 resets the terminal cursor color on exit.
          vim.api.nvim_chan_send(vim.v.stderr, "\027]112\007")
        end,
      })
    end,
    opts = {
      highlight_groups = {
        Cursor = { fg = "#eff1f5", bg = "#dc8a78" },
        CursorNormal = { fg = "#eff1f5", bg = "#dc8a78" },
        CursorInsert = { fg = "#eff1f5", bg = "#40a02b" },
        CursorSelect = { fg = "#eff1f5", bg = "#7287fd" },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "flexoki-light",
    },
  },
}
