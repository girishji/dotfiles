vim9script

iab <buffer> --> ------------------------------------------------------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer> ==> ==============================================================================<c-r>=abbr#Eatchar()<cr>

# Yank the visual selection before using followng abbrevs, to get selection into register 0 or "
# '"' is the default register (:h v:register), when no register is 'active' or specified.
# Registers are also set, so you can use @u, @b, @i macros.
# cabbr <expr> ぬ 's/<c-r>0/ぬ&ぬ<c-r>=abbr#Eatchar()<cr>'
# setreg('u', ":s/\<c-r>0/ぬ&ぬ\<cr>\<esc>")
# cabbr <expr> ぼ 's/<c-r>0/ぼ&ぼ<c-r>=abbr#Eatchar()<cr>'
# setreg('b', ":s/\<c-r>0/ぼ&ぼ\<cr>\<esc>")
# cabbr <expr> ち 's/<c-r>0/ち&ち<c-r>=abbr#Eatchar()<cr>'
# setreg('i', ":s/\<c-r>0/ち&ち\<cr>\<esc>")

import '../../autoload/text.vim'
vnoremap <buffer> <leader>u <scriptcmd>text.Surround('ぬ')<cr>
vnoremap <buffer> <leader>b <scriptcmd>text.Surround('ぼ')<cr>
vnoremap <buffer> <leader>i <scriptcmd>text.Surround('ち')<cr>
