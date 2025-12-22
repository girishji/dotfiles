setlocal commentstring=//%s
setlocal path-=/usr/include

if exists('g:loaded_lsp')
  setlocal omnifunc=g:LspOmniFunc
endif

" setlocal cpt=.^5,o^5,w^5,b^5,u^5


" In insert mode type: FF e 10<CR>
" → for (int e = 0; e < 10; ++e) {
"   }

iabbrev <buffer> FF <C-o>:FF

command! -nargs=* FF call s:FF(<f-args>)

function! s:FF(i, x) abort
  let t = 'for (int ' . a:i . ' = 0; ' . a:i . ' < ' . a:x . '; ++' . a:i . ') {'
  execute 'normal! a' . t
  execute "normal! o \<BS>\<Esc>"
  execute "normal! o}\<Esc>kA"
endfunction
