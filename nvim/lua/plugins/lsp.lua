return {
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     "debugpy",
  --     "deno",
  --     "pyright",
  --     "ruff",
  --     "stylua",
  --     "shfmt",
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
              },
            },
          },
        },
        ruff = {
          trace = "messages",
          -- init_options = { settings = { logLevel = "debug" } },
        },
      },
    },
  },
}
