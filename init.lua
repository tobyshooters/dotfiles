-- Bootstrap plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({{ "Failed to clone lazy.nvim:\n", "ErrorMsg" }}, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Basic Settings
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.opt.diffopt:append("foldcolumn:0")
vim.opt.fillchars = {eob = " "}
vim.opt.backspace = {"indent", "eol", "start"}
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true 
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.lazyredraw = true
vim.opt.showmatch = true
vim.opt.title = true
vim.opt.laststatus = 2
vim.opt.conceallevel = 2
vim.opt.scrolloff = 10
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.foldenable = true
vim.opt.foldnestmax = 2
vim.opt.foldmethod = "manual"
vim.opt.clipboard = "unnamedplus"

function _G.word_count()
  local wc = vim.fn.wordcount()
  local result = ""
  if wc.visual_words then
    result = result .. wc.visual_words .. " of "
  end
  result = result .. wc.words .. " words"
  return result
end

vim.opt.statusline = " %f%m %y %= %{v:lua.word_count()} "


function _G.custom_fold_text()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local content = start_line:gsub("^%s*", "")
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  return string.format("%4d ▶ %s", line_count, content)
end

vim.opt.foldtext = 'v:lua.custom_fold_text()'


-- Key mappings
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "B", "^")
vim.keymap.set("n", "E", "$")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>v", "<C-w>v<C-w>l")
vim.keymap.set("n", "<leader>m", "<C-w>s<C-w>j")
vim.keymap.set("n", "<leader>d", "<C-w>q")
vim.keymap.set("n", "<leader>=", "<C-w>=")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<leader>t", ":tabnew<CR>")
vim.keymap.set("n", "<C-t>", ":tabnext<CR>")
vim.keymap.set("n", "<C-S-t>", ":tabprevious<CR>")
vim.keymap.set("v", "<Space>", "zf")
vim.keymap.set("n", "<Space>", "za")
vim.keymap.set("n", "<leader>p", ":set paste!<CR>")
vim.keymap.set("n", "Y", '"+y')
vim.keymap.set("n", "<Esc>", ":noh<CR>")


-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "javascript", "lua"},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 0
  end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.ts", "*.tsx", "*.jsx", "*.svelte", "*.html"},
  callback = function()
    vim.bo.filetype = "javascript"
  end,
})

-- Markdown folding configuration
vim.g.markdown_folding = 1

function _G.markdown_level()
  local line = vim.fn.getline(vim.v.lnum)
  if line:match("^## .*$") then
    return ">1"
  elseif line:match("^### .*$") then
    return ">2"
  else
    return "="
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.markdown_level()"
  end,
})

-- Load all plugins
require("lazy").setup({
  spec = {
    {
      'maxmx03/solarized.nvim',
      lazy = false,
      priority = 1000,
      opts = { 
        defaults = {
          disable_devicons = true,         
        }
      },
      config = function(_, opts)
        vim.o.termguicolors = true
        vim.o.background = 'light'
        require('solarized').setup(opts)
        vim.cmd.colorscheme 'solarized'

        local function apply_highlights()
          -- How to also make the vim sign column white background?
          local highlights = {
            'highlight Normal       guibg=#ffffff guifg=#000000',
            'highlight WinSeparator guibg=#ffffff guifg=#bcbcbc',
            'highlight VertSplit    guibg=#ffffff guifg=#bcbcbc',
            'highlight Visual       guibg=#ffffaa guifg=none gui=bold',
            'highlight LineNr       guibg=#ffffff guifg=#999999',
            'highlight Folded       guibg=#ffffff guifg=#0000aa',
            'highlight SignColumn   guibg=#ffffff',
            'highlight NonText      guifg=#999999',
            'highlight StatusLine   guifg=#444444 guibg=#dddddd',
            'highlight StatusLineNC guifg=#aaaaaa guibg=#dddddd',

            'highlight! link Folded markdownH2',

            'highlight NeoTreeCursorLine      guibg=#e8e8e8 guifg=#000000',
            'highlight TelescopeBorder        guibg=#ffffff',
            'highlight TelescopePromptBorder  guibg=#ffffff',
            'highlight TelescopeResultsBorder guibg=#ffffff',
            'highlight TelescopePreviewBorder guibg=#ffffff',
            'highlight TelescopeSelection     guibg=#e8e8e8 guifg=#000000',

            'highlight! link NormalFloat Normal',
            'highlight! link NeoTreeNormal Normal',
            'highlight! link TelescopeNormal Normal',
          }
          for _, hl in ipairs(highlights) do
            vim.cmd(hl)
          end
        end

        vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {
          pattern = '*',
          callback = apply_highlights,
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function(_, opts)
        local lspconfig = require('lspconfig')

        lspconfig.lua_ls.setup({})

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
      end
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
      },
      opts = {
        default_component_configs = {
          icon = { enabled = false },
        },
      },
      keys = {
        { "<leader>ft", "<cmd>Neotree filesystem toggle<cr>" }
      },
    },
     {
      "nvim-telescope/telescope.nvim",
      dependencies = { 
        "nvim-lua/plenary.nvim",
      },
      keys = {
        { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>a", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
        { "<leader>ff", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      },
      opts = {
        defaults = {
          file_ignore_patterns = {"node_modules", "DS_Store", "_build", "public"},
        },
      },
    },
    {
      "vimwiki/vimwiki",
      init = function()
        vim.g.vimwiki_list = {{
          path = '~/ideaspace/notes',
          syntax = 'markdown',
          ext = '.md',
          auto_diary_index = 1
        }}
      end,
    },
    {
      "junegunn/goyo.vim",
      dependencies = { "junegunn/limelight.vim" },
      keys = {
        { "<leader>g", "<cmd>Goyo<cr>", desc = "Goyo" },
      },
      config = function()
        vim.g.goyo_height = '80%'
        vim.g.limelight_conceal_ctermfg = 'gray'
        vim.g.limelight_paragraph_span = 100
        
        vim.api.nvim_create_autocmd("User", {
          pattern = "GoyoEnter",
          callback = function()
            vim.cmd("Limelight")
            vim.opt.scrolloff = 999
          end,
        })
        
        vim.api.nvim_create_autocmd("User", {
          pattern = "GoyoLeave",
          callback = function()
            vim.cmd("Limelight!")
            vim.opt.scrolloff = 10
          end,
        })
      end,
    },
    {
      "haya14busa/incsearch.vim",
      keys = {
        { "/", "<Plug>(incsearch-forward)", mode = "n" },
        { "?", "<Plug>(incsearch-backward)", mode = "n" },
        { "g/", "<Plug>(incsearch-stay)", mode = "n" },
      },
    },
    {
      "junegunn/vim-easy-align",
      keys = {
        { "ga", "<Plug>(EasyAlign)", mode = {"n","x"} },
      },
    },
    {
      "tobyshooters/palimpsest",
      dev = true,
      dir = "/home/cristobal/dev/palimpsest"
    },
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "tpope/vim-repeat",
    "Raimondi/delimitMate",
    "othree/html5.vim",
  },
  install = { colorscheme = { "solarized" } },
  checker = { enabled = true },
})
