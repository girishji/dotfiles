vim9script

setlocal commentstring=//%s
setl path-=/usr/include

def Make()
    if filereadable("Makefile")
        Sh make
    else
        var fname = expand("%:p:r")
        exe $"Sh make {fname} && chmod +x {fname} && {fname}"
    endif
enddef

nnoremap <buffer><F5> <scriptcmd>Make()<cr>
b:undo_ftplugin ..= ' | exe "nunmap <buffer> <F5>"'
# nnoremap <silent><buffer> <F5> <cmd>make %<<CR>:redraw!<CR>:!./%<<CR>
# b:undo_ftplugin ..= ' | exe "nunmap <buffer> <F5>"'

if exists("g:loaded_lsp")
    setlocal keywordprg=:LspHover
    nnoremap <silent><buffer> gd <scriptcmd>LspGotoDefinition<CR>
    b:undo_ftplugin ..= ' | setl keywordprg<'
    b:undo_ftplugin ..= ' | exe "nunmap <buffer> gd"'
endif

# In insert mode type 'FF e 10<cr>' and it will insert 'for (int e = 0; e < 10; ++e) {<cr>.'
iab FF <c-o>:FF
command -nargs=* FF call FF(<f-args>)
def FF(i: string, x: string)
    var t = $'for (int {i} = 0; {i} < {x}; ++{i}) {{'
    exe 'normal! a' .. t
    exe "normal o\<space>\<BS>\e"
    exe "normal o}\ekA"
enddef

