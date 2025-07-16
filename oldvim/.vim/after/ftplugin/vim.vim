setl keywordprg=:help

iab <buffer> vim9 vim9script<c-r>=Eatchar()<cr>
iab <buffer><expr> augroup NotCtx('augroup') ? 'augroup'
            \ : 'augroup  \| autocmd!<cr>augroup END<esc>k_ela<c-r>=Eatchar()<cr>'
iab <buffer><expr> def     NotCtx('def') ? 'def'
            \ : 'def <c-o>oenddef<esc>k_ffla<c-r>=Eatchar()<cr>'
iab <buffer><expr> def!    NotCtx('def!') ? 'def!'
            \ : 'def! <c-o>oenddef<esc>k_ffla<c-r>=Eatchar()<cr>'
iab <buffer><expr> func    NotCtx('func') ? 'func'
            \ : 'func <c-o>oendfunc<esc>k_fcla<c-r>=Eatchar()<cr>'
iab <buffer><expr> func!   NotCtx('func!') ? 'func!'
            \ : 'func! <c-o>oendfunc<esc>k_fcla<c-r>=Eatchar()<cr>'
iab <buffer><expr> if      NotCtx('if') ? 'if'
            \ : 'if <c-o>oendif<esc>k_ela<c-r>=Eatchar()<cr>'
iab <buffer><expr> while   NotCtx('while') ? 'while'
            \ : 'while <c-o>oendwhile<esc>k_ela<c-r>=Eatchar()<cr>'
iab <buffer><expr> for     NotCtx('for' ) ? 'for'
            \ : 'for <c-o>oendfor<esc>k_ela<c-r>=Eatchar()<cr>'
