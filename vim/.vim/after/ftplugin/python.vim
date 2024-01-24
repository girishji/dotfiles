vim9script

# https://github.com/habamax/.vim/blob/master/after/ftplugin/python.vim

if executable('black')
    &l:formatprg = "black -q - 2>/dev/null"
elseif executable('yapf')
    # pip install yapf
    &l:formatprg = "yapf"
endif

setlocal foldignore=

b:undo_ftplugin ..= ' | setl foldignore< formatprg<'

# def PydocHelp(symbol: string)
#     :Help symbol<cr>
# enddef

# nnoremap <buffer> <F5> <scriptcmd>exe "Sh python" expand("%:p")<cr>
# b:undo_ftplugin ..= ' | exe "nunmap <buffer> <F5>"'

# if exists("g:loaded_lsp")
#     setlocal keywordprg=:LspHover
#     nnoremap <silent><buffer> gd <scriptcmd>LspGotoDefinition<CR>
#     b:undo_ftplugin ..= ' | setl keywordprg<'
#     b:undo_ftplugin ..= ' | exe "nunmap <buffer> gd"'
# else
#     nnoremap <silent><buffer> K <scriptcmd>PydocHelp(expand("<cfile>"))<CR>
#     xnoremap <silent><buffer> K y<scriptcmd>PydocHelp(getreg('"'))<CR>
#     b:undo_ftplugin ..= ' | exe "nunmap <buffer> K"'
#     b:undo_ftplugin ..= ' | exe "xunmap <buffer> K"'
# endif

import autoload 'popup.vim'

def Things()
    var things = []
    for nr in range(1, line('$'))
        var line = getline(nr)
        if line =~ '\(^\|\s\)\(def\|class\) \k\+('
                || line =~ 'if __name__ == "__main__":'
            things->add({text: $"{line} ({nr})", linenr: nr})
        endif
    endfor
    popup.FilterMenu("Py Things", things,
        (res, key) => {
            exe $":{res.linenr}"
            normal! zz
        },
        (winid) => {
            win_execute(winid, $"syn match FilterMenuLineNr '(\\d\\+)$'")
            hi def link FilterMenuLineNr Comment
        })
enddef
nnoremap <buffer> <space>z <scriptcmd>Things()<CR>
b:undo_ftplugin ..= ' | exe "nunmap <buffer> <space>z"'
