vim9script

hi link markdownCodeBlock Comment

def InCode(s: string): bool
    return synID(line('.'), col('.') - 1, 1)->synIDattr('name') =~? 'markdownCodeBlock'
enddef

iab <buffer> --> ------------------------------------------------------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer> ==> ==============================================================================<c-r>=abbr#Eatchar()<cr>

iab <buffer><expr> nn <SID>InCode('nn') ? 'NOTE:' : 'nn'
