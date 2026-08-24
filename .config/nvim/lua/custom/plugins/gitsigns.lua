-- gitsigns (base config)
-- https://github.com/lewis6991/gitsigns.nvim
-- NOTE: The recommended keymaps are added by kickstart.plugins.gitsigns

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
}
