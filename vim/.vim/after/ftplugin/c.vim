vim9script

setlocal commentstring=//%s
setl path-=/usr/include

if exists("g:loaded_lsp")
    set omnifunc=g:LspOmniFunc
endif

# setlocal cpt=.^5,o^5,w^5,b^5,u^5

# In insert mode type 'FF e 10<cr>' and it will insert 'for (int e = 0; e < 10; ++e) {<cr>.'
iab <buffer> FF <c-o>:FF
command! -nargs=* FF call FF(<f-args>)
def FF(i: string, x: string)
    var t = $'for (int {i} = 0; {i} < {x}; ++{i}) {{'
    exe 'normal! a' .. t
    exe "normal o\<space>\<BS>\e"
    exe "normal o}\ekA"
enddef
