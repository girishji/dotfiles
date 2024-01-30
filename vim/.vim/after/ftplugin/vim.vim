vim9script

# https://github.com/habamax/.vim/blob/master/after/ftplugin/vim.vim

setl textwidth=80
setl keywordprg=:help

iab <buffer> #--- #------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer><expr> augroup abbr#NotCtx() ? 'augroup' : 'augroup  \| autocmd!<cr>augroup END<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> def     abbr#NotCtx() ? 'def' : 'def <c-o>oenddef<esc>k_ffla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> def!    abbr#NotCtx() ? 'def!' : 'def! <c-o>oenddef<esc>k_ffla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> if      abbr#NotCtx() ? 'if' : 'if <c-o>oendif<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> while   abbr#NotCtx() ? 'while' : 'while <c-o>oendwhile<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> for     abbr#NotCtx() ? 'for' : 'for <c-o>oendfor<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer> v9 vim9script<c-r>=abbr#Eatchar()<cr>

# Convince vim that 'def' is a macro like C's #define
setlocal define=^\\s*def
b:undo_ftplugin ..= ' | setlocal define<'

import autoload 'popup.vim'

def Things()
    var things = []
    for nr in range(1, line('$'))
        var line = getline(nr)
        if line =~ '\(^\|\s\)def \k\+('
        || line =~ '\(^\|\s\)fu\%[nction]!\?\s\+\([sgl]:\)\?\k\+('
        || line =~ '^\s*com\%[mand]!\?\s\+\S\+'
        || line =~ '^\s*aug\%[roup]\s\+\S\+' && line !~ '\c^\s*aug\%[roup] end\s*$'
            if line =~ '^\s*com\%[mand]!\?\s\+\S\+'
                line = line->substitute(' -\(range\|count\|nargs\)\(=.\)\?', '', 'g')
                line = line->substitute(' -\(bang\|buffer\)', '', '')
                line = line->substitute(' -complete=\S\+', '', '')
                line = line->substitute('^\s*com\%[mand]!\?\s\+\S\+\zs.*', '', '')
                line = line->substitute('^\s*com\%[mand]!\?\s\+', '', '')
            endif
            things->add({text: $"{line} ({nr})", linenr: nr})
        endif
    endfor
    popup.FilterMenu("Vim Things", things,
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
