-- Bootstrap plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
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
    result = "selected " .. wc.visual_words .. " of "
  end
  result = result .. wc.words .. " words"
  return result
end

vim.opt.statusline = " %f%{&modified ? ' was modified ' : ''} %= line %l of %L, %{v:lua.word_count()} "


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
vim.keymap.set("n", "<leader>T", ":tabnew<CR>")
vim.keymap.set("n", "<C-t>", ":tabnext<CR>")
vim.keymap.set("n", "<C-S-t>", ":tabprevious<CR>")
vim.keymap.set("v", "<Space>", "zf")
vim.keymap.set("n", "<Space>", "za")
vim.keymap.set("n", "<leader>p", ":set paste!<CR>")
vim.keymap.set("n", "Y", '"+y')
vim.keymap.set("n", "<Esc>", ":noh<CR>")

-- Writing
-- Split paragraph into one sentence per line
vim.keymap.set("v", "<leader>s", [[J:s/\([.!?]"\=\)\( \=\[.\{-}\]\)\= \([A-Z]\)/\1\2\r\r\3/g<CR>'[V']gq]])
vim.keymap.set("v", "<leader>j", [[Jgvgq]])


-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"text", "markdown"},
  callback = function()
    vim.opt_local.textwidth = 78
    vim.cmd("syntax sync minlines=200")
  end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"c", "javascript", "lua", "*.ts", "*.tsx", "*.jsx", "*.svelte", "*.html"},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 0
  end,
})



-- Postscript
local function ps_to_pdf()
  local current_file = vim.fn.expand('%:p')
  if not current_file or current_file == '' or not vim.fn.match(current_file, '\\.ps$') == -1 then
    return
  end

  local pdf_file = vim.fn.substitute(current_file, '\\.ps$', '.pdf', '')
  local cmd = string.format('gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="%s" "%s"', pdf_file, current_file)
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    print("Error converting to PDF: " .. result)
    return
  end

  vim.fn.system(string.format('nohup xdg-open "%s" >/dev/null 2>&1 &', pdf_file))
  vim.b.ps_auto_convert = true
end

vim.keymap.set('n', '<leader>pp', function() ps_to_pdf() end)

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.ps',
  callback = function()
    if vim.b.ps_auto_convert then
      ps_to_pdf()
    end
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

-- Vimwiki tags, which live on their own line, as :one: :two:
local wiki = '/home/cristobal/Documents/aguafuerte'
local wiki_index = wiki .. '/index.md'

local function buf_tags(buf)
  local tags = {}
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line:match('^:%S.*:$') then
      for tag in line:gmatch('[^:%s]+') do
        table.insert(tags, tag)
      end
    end
  end
  table.sort(tags)
  return table.concat(tags, ' ')
end

local function insert_tag(tag)
  -- A tag holds no whitespace or colons, so a freshly typed one gets dashed
  tag = vim.trim(tag):lower():gsub('[%s:]+', '-')
  if tag == '' then
    return
  end

  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  if line:match('^:%S.*:$') then
    vim.api.nvim_set_current_line(line .. ' :' .. tag .. ':')
  elseif line:match('^%s*$') then
    vim.api.nvim_set_current_line(':' .. tag .. ':')
  else
    vim.api.nvim_buf_set_lines(0, row, row, false, {':' .. tag .. ':'})
    vim.api.nvim_win_set_cursor(0, {row + 1, 0})
  end
end

local function tag_picker()
  local actions = require('telescope.actions')
  local state = require('telescope.actions.state')

  local tags = vim.fn['vimwiki#tags#get_tags']()
  table.sort(tags)

  require('telescope.pickers').new({}, {
    prompt_title = 'Wiki tags',
    finder = require('telescope.finders').new_table(tags),
    sorter = require('telescope.config').values.generic_sorter({}),
    attach_mappings = function(bufnr, map)
      actions.select_default:replace(function()
        local entry = state.get_selected_entry()
        local prompt = state.get_current_line()
        actions.close(bufnr)
        insert_tag(entry and entry[1] or prompt)
      end)

      -- Take the prompt as written, for a tag that doesn't exist yet
      map({'i', 'n'}, '<C-a>', function()
        local prompt = state.get_current_line()
        actions.close(bufnr)
        insert_tag(prompt)
      end)

      return true
    end,
  }):find()
end

local function regen_tags()
  local buf = vim.fn.bufadd(wiki_index)
  vim.fn.bufload(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd('VimwikiRebuildTags')
    vim.cmd('VimwikiGenerateTagLinks')
    vim.cmd('silent write')
  end)
end

vim.keymap.set('n', '<leader>tt', tag_picker)
vim.keymap.set('n', '<leader>tr', regen_tags)

-- Regenerate the index whenever a write changes a page's tags
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = wiki .. '/*.md',
  callback = function(a) vim.b[a.buf].tags_indexed = buf_tags(a.buf) end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = wiki .. '/*.md',
  -- Nested, so loading index.md below sets its filetype and wiki commands
  nested = true,
  callback = function(a)
    local tags = buf_tags(a.buf)
    if a.file == wiki_index or tags == (vim.b[a.buf].tags_indexed or '') then
      return
    end

    vim.b[a.buf].tags_indexed = tags
    regen_tags()
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

        local themes = { 'light', 'midnight' }
        _G.theme_index = 1

        local function apply_light()
          vim.o.background = 'light'
          vim.cmd.colorscheme 'solarized'
          for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
            if hl.bg and (hl.bg == 0xfdf6e3 or hl.bg == 0xeee8d5) then
              vim.api.nvim_set_hl(0, name, { fg = hl.fg, bg = "#ffffff" })
            end
          end
          local highlights = {
            'highlight Normal       guifg=#000000',
            'highlight WinSeparator guibg=#ffffff guifg=#bcbcbc',
            'highlight VertSplit    guifg=#bcbcbc',
            'highlight Visual       guibg=#bbff91 guifg=none gui=bold',
            'highlight LineNr       guifg=#999999',
            'highlight Folded       guifg=#0000aa',
            'highlight NonText      guifg=#999999',
            'highlight StatusLine   guifg=#444444 guibg=#dddddd',
            'highlight StatusLineNC guifg=#aaaaaa guibg=#dddddd',
            'highlight FloatBorder  guibg=#ffffff',
            'highlight! link Folded markdownH2',
            'highlight! link NormalFloat Normal',
            'highlight! link NeoTreeNormal Normal',
            'highlight! link TelescopeNormal Normal',
            'highlight NeoTreeCursorLine      guibg=#e8e8e8 guifg=#000000',
            'highlight TelescopeSelection     guibg=#e8e8e8 guifg=#000000',
          }
          for _, hl in ipairs(highlights) do
            vim.cmd(hl)
          end
          vim.opt.cursorline = false
          io.write('\027]112;\a')
          io.write('\027]10;#000000\a\027]11;#FFFFFF\a')
        end

        local function apply_midnight()
          vim.o.background = 'dark'
          vim.cmd.colorscheme 'solarized'
          for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
            if hl.bg then
              vim.api.nvim_set_hl(0, name, { fg = hl.fg, bg = "#0050D4" })
            end
          end
          local highlights = {
            'highlight Normal       guifg=#FFFFFF guibg=#0050D4',
            'highlight WinSeparator guibg=#0050D4 guifg=#5588DD',
            'highlight VertSplit    guifg=#5588DD',
            'highlight Visual       guibg=#0070FF guifg=#FFFFFF gui=bold',
            'highlight LineNr       guifg=#88AADD',
            'highlight Folded       guifg=#00FFFF guibg=#0050D4',
            'highlight NonText      guifg=#5588DD',
            'highlight StatusLine   guifg=#00FFFF guibg=#003DA0',
            'highlight StatusLineNC guifg=#5588DD guibg=#003DA0',
            'highlight FloatBorder  guibg=#0050D4',
            'highlight NormalFloat  guifg=#FFFFFF guibg=#0050D4',
            'highlight NeoTreeNormal      guifg=#FFFFFF guibg=#0050D4',
            'highlight TelescopeNormal    guifg=#FFFFFF guibg=#0050D4',
            'highlight NeoTreeCursorLine  guibg=#0070FF guifg=#FFFFFF',
            'highlight TelescopeSelection guibg=#0070FF guifg=#FFFFFF',
            'highlight Cursor       guibg=#00FF88 guifg=#000000',
            'highlight TermCursor   guibg=#00FF88 guifg=#000000',
            'highlight CursorLine   guibg=#003DA0',
            'highlight Title        guifg=#00FF88 gui=bold',
            'highlight String       guifg=#00FFAA',
            'highlight Constant     guifg=#FF88CC',
            'highlight Special      guifg=#88CCFF',
            'highlight Identifier   guifg=#66FFCC',
            'highlight Statement    guifg=#88FF44',
            'highlight Function     guifg=#44DDFF',
            'highlight Type         guifg=#FFCC44',
            'highlight Comment      guifg=#88AADD',
            'highlight Keyword      guifg=#88FF44 gui=bold',
            'highlight Delimiter    guifg=#AACCFF',
            'highlight Underlined   guifg=#44DDFF gui=underline',
            'highlight! link @markup.link.url Underlined',
            'highlight! link @markup.link Underlined',
            'highlight! link @markup.link.label Function',
          }
          for _, hl in ipairs(highlights) do
            vim.cmd(hl)
          end
          vim.opt.cursorline = true
          io.write('\027]12;#00FF88\a')
          io.write('\027]10;#FFFFFF\a\027]11;#0050D4\a')
        end

        local apply = { light = apply_light, midnight = apply_midnight }

        function _G.apply_theme()
          apply[themes[_G.theme_index]]()
        end

        vim.keymap.set('n', '<leader>bg', function()
          _G.theme_index = (_G.theme_index % #themes) + 1
          _G.apply_theme()
        end)

        vim.api.nvim_create_autocmd('VimLeavePre', {
          callback = function() io.write('\027]110;\a\027]111;\a') end,
        })

        vim.api.nvim_create_autocmd({'VimEnter', 'ColorScheme'}, {
          pattern = '*',
          callback = _G.apply_theme,
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require('lspconfig')

        vim.diagnostic.config({
          signs = true,
          virtual_text = {
            prefix = '',
            spacing = 0,
            format = function(diagnostic)
              local bufnr = vim.api.nvim_get_current_buf()
              local line_nr = diagnostic.lnum
              local line_content = vim.api.nvim_buf_get_lines(bufnr, line_nr, line_nr + 1, false)[1] or ""
              local padding = math.max(1, 80 - #line_content)
              return string.rep(' ', padding) .. diagnostic.message
            end,
          }
        })

        -- lspconfig.lua_ls.setup({
        --   cmd = { vim.fn.expand("~/dev/lua-language-server/bin/lua-language-server") },
        --   settings = { Lua = { diagnostics = { globals = {'vim'} } } }
        -- })

        lspconfig.ts_ls.setup({
          filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
          root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
        })

        lspconfig.pyright.setup({
          settings = {
            python = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportMissingImports = "none",
                  reportMissingModuleSource = "none",
                }
              }
            }
          }
        })

        vim.keymap.set('n', 'gd',         vim.lsp.buf.definition)
        vim.keymap.set('n', 'gb',         '<C-o>')
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)

        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
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
          path = wiki,
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
            vim.defer_fn(_G.apply_theme, 50)
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
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      opts = {
        ensure_installed = { "markdown", "markdown_inline", "lua", "javascript", "typescript", "python", "html" },
        highlight = { enable = true },
      },
    },
    {
        "https://github.com/3rd/image.nvim",
        build = false,
        opts = {
            backend = "kitty",
            processor = "magick_cli",
            max_width = 80,
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                },
            },
        }
    },
    {
      "HakonHarnes/img-clip.nvim",
      opts = {
        default = {
          -- Save the image in an "images" folder next to the file being edited
          dir_path = "images",
          relative_to_current_file = true,
          -- Markdown embed
          template = "![$CURSOR]($FILE_PATH)",
          prompt_for_file_name = false,
          file_name = "%Y-%m-%d-%H-%M-%S",
        },
      },
      keys = {
        { "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
      },
    },
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "tpope/vim-repeat",
    "Raimondi/delimitMate",
    "othree/html5.vim",
  },
  install = { colorscheme = { "solarized" } },
})
