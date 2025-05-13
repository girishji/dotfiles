iab <buffer> --> ------------------------------------------------------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer> ==> ==============================================================================<c-r>=abbr#Eatchar()<cr>

vnoremap <buffer> <leader>u :call <SID>Surround('ぬ')<cr>
vnoremap <buffer> <leader>b :call <SID>Surround('ぼ')<cr>
vnoremap <buffer> <leader>i :call <SID>Surround('ち')<cr>

func s:Surround(c)
  if mode() == 'n'
    normal! diw
    exe $'normal! i{c}{c}'
    normal! P
  elseif mode() != 'CTRL-V'
    let [line_start, col_start] = getpos('v')[1 : 2]
    let [line_end, col_end] = getpos('.')[1 : 2]
    if mode() == 'V'
      let col_start = 0
      let col_end = v:maxcol
    endif
    let reverse = line_start > line_end || (line_start == line_end && col_start > col_end)
    for lnum in range(line_start, line_end, reverse ? -1 : 1)
      let line = lnum->getline()
      let start = lnum == line_start ? col_start - 1 : (reverse ? line->len() : 0)
      let end = lnum == line_end ? col_end - 1 : (reverse ? 0 : line->len())
      let newline = reverse ?
        $'{line->strpart(0, end)}{c}{line->strpart(end, start - end + 1)}{c}{line->strpart(start + 1)}' :
        $'{line->strpart(0, start)}{c}{line->strpart(start, end - start + 1)}{c}{line->strpart(end + 1)}'
      call newline->setline(lnum)
    endfor
  endif
endfunc

" vim: shiftwidth=2 sts=2 expandtab
