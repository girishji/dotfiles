iab <buffer> --> ------------------------------------------------------------------------------<c-r>=Eatchar()<cr>
iab <buffer> ==> ==============================================================================<c-r>=Eatchar()<cr>

vnoremap <buffer> <leader>u :call <SID>Surround('ぬ')<cr>
vnoremap <buffer> <leader>b :call <SID>Surround('ぼ')<cr>
vnoremap <buffer> <leader>i :call <SID>Surround('ち')<cr>
" Note: ':' above puts vim in cmd-mode (from visual mode)

function! s:Surround(c) range
  if visualmode() ==# 'CTRL-V'
    return
  endif

  let [ls, cs] = getpos("'<")[1:2]
  let [le, ce] = getpos("'>")[1:2]

  if visualmode() ==# 'V'
    let [cs, ce] = [0, v:maxcol]
  endif

  for lnum in range(ls, le)
    let line = getline(lnum)
    let start = (lnum == ls ? cs - 1 : 0)
    let end   = (lnum == le ? ce - 1 : len(line) - 1)
    let newline = (start > 0 ? line[:start-1] : '') . a:c . line[start:end] . a:c . line[end+1:]
    call setline(lnum, newline)
  endfor
endfunction

" vim: shiftwidth=2 sts=2 expandtab
