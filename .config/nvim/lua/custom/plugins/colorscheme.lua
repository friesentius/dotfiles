-- kanso colorscheme
-- https://github.com/webhooked/kanso.nvim

return {
  'webhooked/kanso.nvim',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require('kanso').setup {
      transparent = true,
      background = {
        dark = 'zen',
        light = 'pearl',
      },
    }

    vim.cmd.colorscheme 'kanso'
  end,
}
