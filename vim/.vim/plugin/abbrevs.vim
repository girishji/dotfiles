" Note:
" Trigger abbrev without typing <space> by using <c-]>
" <c-c> instead of <esc> to prevent expansion
" <c-v> to avoid the abbrev expansion in Insert mode (alternatively, <esc>i)
" <c-v> twice to avoid the abbrev expansion in command-line mode

func! Eatchar()
    let c = nr2char(getchar(0))
    return (c =~ '\s\|/') ? '' : c  " eat space and '/'
endfunc

func! NotCtx(s)
    if synID(line('.'), col('.') - 1, 1)->synIDattr('name') =~? '\vcomment|string|character|doxygen'
        return 1
    elseif !a:s->empty() " inside a comment, but check if there is a space behind 's'
        let line = getline(line('.'))
        if line->len() > (a:s->len() + 1) && line[col('.') - 2 - a:s->len()] != ' '
            return 1
        endif
    endif
    return 0
endfunc

" func EOL()
"     return col('.') == col('$') || getline('.')->strpart(col('.')) =~ '^\s\+$'
" endfunc

func! CmdAbbr(abbr, expn, range = 0)
    if getcmdtype() == ':'
        let ctx = getcmdline()->strpart(0, getcmdpos() - 1)
        if a:range
            let pat = '^\(''<,''>\|''\a,''\a\|%\|\d\+\|\d\+,\d\+\)\=' " \?, \=, \{0,1} are equivalent
            ctx->substitute(pat, '', '')
        endif
        if ctx =~ $'^\({a:abbr}\|vim9\s\+{a:abbr}\)$'
            return a:expn
        endif
    endif
    return a:abbr
endfunc

" 'vim' same as 'vimgrep' (can use Vim style regex)
cabbr <expr> lv CmdAbbr('lv', $'lv // %<left><left><left><c-r>=Eatchar()<cr>')

cabbr gr grep

" Modeline
iabbr vim_help_modeline vim:tw=78:ts=4:ft=help:norl:ma:noro:ai:lcs=tab\:\ \ ,trail\:~:<c-r>=Eatchar()<cr>
iabbr vim_txt_modeline vim:ft=txt:<c-r>=Eatchar()<cr>
iabbr vim_markdown_modeline vim:tw=80:ts=4:ft=markdown:ai:<c-r>=Eatchar()<cr>
iabbr vim_vim_modeline " vim: shiftwidth=2 sts=2 expandtab<c-r>=Eatchar()<cr>
iabbr vim_vim9_modeline " vim: ts=4 shiftwidth=4 sts=4 expandtab<c-r>=Eatchar()<cr>

" dashes to match previous line length (there are also key maps in keymappings.vim)
iab  --> <esc>d^a<c-r>=repeat('-', getline(line('.') - 1)->trim()->len())<cr><c-r>=Eatchar()<cr>
iab  ==> <esc>d^a<c-r>=repeat('=', getline(line('.') - 1)->trim()->len())<cr><c-r>=Eatchar()<cr>
iab  ~~> <esc>d^a<c-r>=repeat('~', getline(line('.') - 1)->trim()->len())<cr><c-r>=Eatchar()<cr>
iab  --* ----------------------------------------------------------------------<c-r>=Eatchar()<cr>
iab  ==* ======================================================================<c-r>=Eatchar()<cr>

" insert date, and time
" inorea dd <C-r>=strftime("%Y-%m-%d")<CR><C-R>=Eatchar()<CR>
" inorea ddd <C-r>=strftime("%Y-%m-%d %H:%M")<CR><C-R>=Eatchar()<CR>

" inorea todo: TODO:
inorea fixme: FIXME:
inorea xxx: XXX:
inorea xxx XXX:
inorea note: NOTE:
inorea Note: NOTE:

" Can have iab that inserted #replaceme# at various places and have a
" keymap that jumped to the next #replaceme# and did ciW.
" Can set a buffer variable that abbrev is expanded, and map <tab> to hop to
" specific locations.

" vim: shiftwidth=2 sts=2 expandtab
