local cursor_colors = {
  fg = "#eff1f5",
  normal = "#dc8a78",
  insert = "#40a02b",
  select = "#7287fd",
}

local function can_set_terminal_cursor_color()
  -- Warp currently does not reliably honor dynamic cursor colors from Neovim.
  -- Keep the Neovim-side highlight config, but avoid sending extra cursor-color
  -- escape sequences there.
  return vim.env.TERM_PROGRAM ~= "WarpTerminal" and #vim.api.nvim_list_uis() > 0
end

return {
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    init = function()
      vim.opt.guicursor = table.concat({
        "n-c-o-sm:block-CursorNormal",
        "i-ci:block-CursorInsert",
        "v-ve:block-CursorSelect",
        "r-cr:hor20-CursorInsert",
        "t:block-CursorInsert",
      }, ",")

      local function set_terminal_cursor_color(color)
        if can_set_terminal_cursor_color() then
          -- OSC 12 sets the terminal cursor color in terminals such as Ghostty.
          pcall(vim.api.nvim_chan_send, vim.v.stderr, "\027]12;" .. color .. "\007")
        end
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
          if can_set_terminal_cursor_color() then
            -- OSC 112 resets the terminal cursor color on exit.
            pcall(vim.api.nvim_chan_send, vim.v.stderr, "\027]112\007")
          end
        end,
      })
    end,
    opts = {
      highlight_groups = {
        Cursor = { fg = cursor_colors.fg, bg = cursor_colors.normal },
        CursorNormal = { fg = cursor_colors.fg, bg = cursor_colors.normal },
        CursorInsert = { fg = cursor_colors.fg, bg = cursor_colors.insert },
        CursorSelect = { fg = cursor_colors.fg, bg = cursor_colors.select },
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
