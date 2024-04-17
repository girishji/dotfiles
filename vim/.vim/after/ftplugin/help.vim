vim9script

iab <buffer> --- ------------------------------------------------------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer> === ==============================================================================<c-r>=abbr#Eatchar()<cr>

# Yank the visual selection before using followng abbrevs, to get selection into register 0 or "
# '"' is the default register (:h v:register), when no register is 'active' or specified.
# Registers are also set, so you can use @u, @b, @i macros.
# cabbr <expr> ぬ 's/<c-r>0/ぬ&ぬ<c-r>=abbr#Eatchar()<cr>'
# setreg('u', ":s/\<c-r>0/ぬ&ぬ\<cr>\<esc>")
# cabbr <expr> ぼ 's/<c-r>0/ぼ&ぼ<c-r>=abbr#Eatchar()<cr>'
# setreg('b', ":s/\<c-r>0/ぼ&ぼ\<cr>\<esc>")
# cabbr <expr> ち 's/<c-r>0/ち&ち<c-r>=abbr#Eatchar()<cr>'
# setreg('i', ":s/\<c-r>0/ち&ち\<cr>\<esc>")

def Markup(c: string)
    if mode() == 'CTRL-V'
        return
    endif
    var [line_start, col_start] = getpos('v')[1 : 2]
    var [line_end, col_end] = getpos('.')[1 : 2]
    if mode() == 'V'
        col_start = 0
        col_end = v:maxcol
    endif
    var reverse = line_start > line_end || (line_start == line_end && col_start > col_end)
    for lnum in range(line_start, line_end, reverse ? -1 : 1)
        var line = lnum->getline()
        var start = lnum == line_start ? col_start - 1 : (reverse ? line->len() : 0)
        var end = lnum == line_end ? col_end - 1 : (reverse ? 0 : line->len())
        var newline = reverse ?
            $'{line->strpart(0, end)}{c}{line->strpart(end, start - end + 1)}{c}{line->strpart(start + 1)}' :
            $'{line->strpart(0, start)}{c}{line->strpart(start, end - start + 1)}{c}{line->strpart(end + 1)}'
        newline->setline(lnum)
    endfor
enddef

vnoremap <buffer> <leader>u <scriptcmd>Markup('ぬ')<cr>
vnoremap <buffer> <leader>b <scriptcmd>Markup('ぼ')<cr>
vnoremap <buffer> <leader>i <scriptcmd>Markup('ち')<cr>
