return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  -- init = function()
  --   local wk = require("which-key")
  --   wk.add({
  --     ["<leader>sc"] = { ":Silicon<CR>" },
  --   })
  -- end,
  config = function()
    require("silicon").setup({
      font = "JetBrainsMono Nerd Font=34",
    })
  end,
}
