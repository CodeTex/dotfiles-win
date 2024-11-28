return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "debugpy" } },
  },
  {
    "nvim-neotest/neotest-python",
    config = function()
      local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason")
      local path = mason_path .. "/packages/debugpy/venv"
      if vim.fn.has("win32") == 1 then
        path = path .. "/Scripts/python.exe"
      else
        path = path .. "/bin/python"
      end
      require("dap-python").setup(path)
    end,
  },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = {
            justMyCode = false,
            console = "integratedTerminal",
          },
          args = { "--log-level", "DEBUG", "--quiet" },
          runner = "pytest",
          python = {
            -- "venv/bin/python",
            -- ".venv/bin/python",
            -- "venv/Scripts/python.exe",
            ".venv/Scripts/python.exe",
          },
        },
      },
    },
  },
}

-- vim.g.lazyvim_python_lsp = "pyright"
-- vim.g.lazyvim_python_ruff = "ruff"
--
-- return {
--   {
--     "williamboman/mason.nvim",
--     opts = {
--       ensure_installed = {
--         "debugpy",
--         "pyright",
--         "ruff",
--       },
--     },
--   },
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = {
--       ensure_installed = { "python", "rst" },
--     },
--   },
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         pyright = {
--           enabled = true,
--           settings = {
--             pyright = {
--               disabledOrganizeImports = true, -- use ruff for import sorting
--             },
--             python = {
--               analysis = {
--                 -- ignore = { "*" }, -- disable pyright linting in favor of ruff
--                 typeCheckingMode = "basic",
--               },
--             },
--           },
--         },
--         ruff = {
--           enabled = true,
--           cmd_env = { RUFF_TRACE = "messages" },
--           init_options = {
--             settings = { logLevel = "error" },
--           },
--           keys = {
--             {
--               "<leader>co",
--               LazyVim.lsp.action["source.organizeImports"],
--               desc = "Organize Imports",
--             },
--           },
--         },
--       },
--       setup = {
--         ["ruff"] = function()
--           LazyVim.lsp.on_attach(function(client, _)
--             client.server_capabilities.hoverProvider = false
--           end, "ruff")
--         end,
--       },
--     },
--   },
--   {
--     "linux-cultist/venv-selector.nvim",
--     branch = "regexp", -- Use this branch for the new version
--     cmd = "VenvSelect",
--     enabled = function()
--       return LazyVim.has("telescope.nvim")
--     end,
--     opts = {
--       settings = {
--         options = {
--           notify_user_on_venv_activation = true,
--         },
--       },
--     },
--     --  Call config for python files and load the cached venv automatically
--     ft = "python",
--     keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
--   },
--   {
--     "nvim-neotest/neotest",
--     optional = true,
--     dependencies = {
--       "nvim-neotest/neotest-python",
--     },
--     opts = {
--       adapters = {
--         ["neotest-python"] = {
--           -- runner = "pytest",
--           -- python = ".venv/bin/python",
--         },
--       },
--     },
--   },
--   {
--     "mfussenegger/nvim-dap",
--     optional = true,
--     dependencies = {
--       "mfussenegger/nvim-dap-python",
--       -- stylua: ignore
--       keys = {
--         { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
--         { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
--       },
--       config = function()
--         if vim.fn.has("win32") == 1 then
--           local path = "~/AppData/Local/nvim-data/mason/packages/debugpy/venv/Scripts/python.exe"
--           require("dap-python").setup(path)
--           -- require("dap-python").setup(LazyVim.get_pkg_path("debugpy", ".venv/Scripts/python.exe"))
--         else
--           require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"))
--         end
--       end,
--     },
--   },
--   {
--     "hrsh7th/nvim-cmp",
--     opts = function(_, opts)
--       opts.auto_brackets = opts.auto_brackets or {}
--       table.insert(opts.auto_brackets, "python")
--     end,
--   },
--   {
--     "jay-babu/mason-nvim-dap.nvim",
--     optional = true,
--     opts = {
--       handlers = {
--         python = function() end,
--       },
--     },
--   },
-- }
