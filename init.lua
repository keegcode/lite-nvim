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
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "David-Kunz/gen.nvim",
    opts = {
        model = "deepseek-r1:32b", -- The default model to use.
        quit_map = "q", -- set keymap to close the response window
        display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
        show_prompt = true, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
        
        show_model = true, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = true, -- Never closes the window automatically.
        init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
        -- Function to initialize Ollama
        command = function(options)
            local body = {model = options.model, temperature = 0.0, stream = true}
            return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
        end,
    }
},
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
    "yaml",
    "glsl"
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
    "ts_ls",
    "glsl_analyzer"
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

lspconfig.glsl_analyzer.setup {
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
  let g:prettier#exec_cmd_async = 1
  let g:prettier#autoformat = 0
]])
