vim.cmd('source ~/dotfiles/vimrc')

require('palimpsest').setup({
    mark = {
        first = "claude ⤵",
        final = "claude ⤴",
    }
})

vim.o.showmode = false
