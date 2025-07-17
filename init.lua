-- Bootstrap plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Basic Settings
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.opt.showmode = false
vim.opt.diffopt:append("foldcolumn:0")
vim.opt.fillchars = {eob = " "}
vim.opt.backspace = {"indent", "eol", "start"}
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.number = true
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

        vim.cmd([[
          autocmd VimEnter,ColorScheme * highlight Normal guibg=#ffffff
          autocmd VimEnter,ColorScheme * highlight WinSeparator guibg=#ffffff guifg=#bcbcbc
          autocmd VimEnter,ColorScheme * highlight VertSplit guibg=#ffffff guifg=#bcbcbc
          autocmd VimEnter,ColorScheme * highlight Visual guibg=#ffffaa gui=bold

          autocmd VimEnter,ColorScheme * highlight LineNr guibg=#ffffff guifg=#999999
          autocmd VimEnter,ColorScheme * highlight Visual guibg=#ffffaa gui=bold
          autocmd VimEnter,ColorScheme * highlight Folded guibg=#ffffff guifg=#0000aa
          autocmd VimEnter,ColorScheme * highlight NonText guifg=#999999
          autocmd VimEnter,ColorScheme * highlight StatusLine guifg=#444444 guibg=#dddddd
          autocmd VimEnter,ColorScheme * highlight StatusLineNC guifg=#aaaaaa guibg=#dddddd

          autocmd VimEnter,ColorScheme * highlight! link NormalFloat Normal
          autocmd VimEnter,ColorScheme * highlight! link NeoTreeNormal Normal
          autocmd VimEnter,ColorScheme * highlight! link TelescopeNormal Normal

          autocmd VimEnter,ColorScheme * highlight NeoTreeCursorLine guibg=#e8e8e8 guifg=#000000

          autocmd VimEnter,ColorScheme * highlight TelescopeBorder guibg=#ffffff
          autocmd VimEnter,ColorScheme * highlight TelescopePromptBorder guibg=#ffffff
          autocmd VimEnter,ColorScheme * highlight TelescopeResultsBorder guibg=#ffffff
          autocmd VimEnter,ColorScheme * highlight TelescopePreviewBorder guibg=#ffffff
          autocmd VimEnter,ColorScheme * highlight TelescopeSelection guibg=#e8e8e8 guifg=#000000

        ]])
      end,
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
        { "ga", "<Plug>(EasyAlign)", mode = "n" },
      },
    },
    "tobyshooters/palimpsest",
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "tpope/vim-repeat",
    "Raimondi/delimitMate",
    "othree/html5.vim",
  },
  install = { colorscheme = { "solarized" } },
  checker = { enabled = true },
})
