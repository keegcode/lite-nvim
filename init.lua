vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  {
    "L3MON4D3/LuaSnip"
  },
  {
    "saadparwaiz1/cmp_luasnip"
  },
  {
    "hrsh7th/cmp-nvim-lsp"
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
    "projekt0n/github-nvim-theme",
  },
  {
    "jesseduffield/lazygit",
  },
  {
    "windwp/nvim-ts-autotag",
  },
  {
    "prettier/vim-prettier",
  }
}

local opts = {}

require("lazy").setup(plugins, opts)

require("ibl").setup({})

vim.keymap.set("n", "<leader>e", "<cmd>Ex<cr>")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fs", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>fg", builtin.git_status, {})

local config = require("nvim-treesitter.configs")

config.setup({
  ensure_installed = {
    "lua", 
    "javascript", 
    "typescript", 
    "rust", 
    "go", 
    "dockerfile", 
    "c", 
    "cmake", 
    "cpp",
    "html",
    "tsx",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

require("github-theme").setup({
  options = { transparent = true },
})

vim.cmd("colorscheme github_dark_high_contrast")

require("mason").setup({})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls", 
    "rust_analyzer", 
    "dockerls", 
    "eslint", 
    "gopls", 
    "jsonls", 
    "clangd",
    "cmake",
    "html",
    "tailwindcss",
    "unocss",
    "ts_ls"
  }
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup {
  capabilities = capabilities  
}

lspconfig.eslint.setup {
  capabilities = capabilities  
}

lspconfig.dockerls.setup {
  capabilities = capabilities  
}

lspconfig.gopls.setup {
  capabilities = capabilities  
}

lspconfig.jsonls.setup {
  capabilities = capabilities  
}

lspconfig.clangd.setup {
  capabilities = capabilities  
}

lspconfig.cmake.setup {
  capabilities = capabilities  
}

lspconfig.html.setup {
  capabilities = capabilities  
}

lspconfig.tailwindcss.setup {
  capabilities = capabilities  
}

lspconfig.unocss.setup {
  capabilities = capabilities  
}

lspconfig.ts_ls.setup {
  capabilities = capabilities  
}

require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true, 
    enable_close_on_slash = false 
  },
  per_filetype = {
    ["html"] = {
      enable_close = true 
    },
    ["tsx"] = {
      enable_close = true
    },
    ["jsx"] = {
      enable_close = true 
    },
    ["js"] = {
      enable_close = true 
    },
    ["ts"] = {
      enable_close = true 
    }
  }
})

vim.cmd([[
  let g:prettier#autoformat_require_pragma = 0 
  let g:prettier#exec_cmd_async = 1
  let g:prettier#autoformat_config_files = [".prettierrc", ".prettierrc.config.mjs", ".prettierrc.mjs", ".prettierrc.js", ".prettierrc.json", ".prettierrc.yaml", ".prettierrc.yml", ".prettierrc.toml", "prettier.config.js", "prettier.config.cjs", ".prettierrc.cjs"]
  let g:prettier#autoformat_config_present = 1
]])
