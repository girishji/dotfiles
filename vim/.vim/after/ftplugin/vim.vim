vim9script

setl keywordprg=:help

iab <buffer><expr> augroup abbr#NotCtx('augroup') ? 'augroup'
            \ : 'augroup  \| autocmd!<cr>augroup END<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> def     abbr#NotCtx('def') ? 'def'
            \ : 'def <c-o>oenddef<esc>k_ffla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> def!    abbr#NotCtx('def!') ? 'def!'
            \ : 'def! <c-o>oenddef<esc>k_ffla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> func     abbr#NotCtx('func') ? 'func'
            \ : 'func <c-o>oendfunc<esc>k_fcla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> func!    abbr#NotCtx('func!') ? 'func!'
            \ : 'func! <c-o>oendfunc<esc>k_fcla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> if      abbr#NotCtx('if') ? 'if'
            \ : 'if <c-o>oendif<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> while   abbr#NotCtx('while') ? 'while'
            \ : 'while <c-o>oendwhile<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> for     abbr#NotCtx('for' ) ? 'for'
            \ : 'for <c-o>oendfor<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
