vim.cmd('source ~/dotfiles/vimrc')

package.path = package.path .. ';/home/cristobal/dotfiles/?.lua'
require('claude')
