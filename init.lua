vim.cmd('source ~/dotfiles/vimrc')
package.path = package.path .. ';/home/cristobal/dotfiles/?.lua'

require('claude').setup({
    mark = {
        first = "claude ⤵",
        final = "claude ⤴",
    }
})

vim.o.showmode = false
