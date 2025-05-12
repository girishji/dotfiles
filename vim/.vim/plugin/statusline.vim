" Statusline with buffer list

augroup UpdateStatusline | autocmd!
  autocmd WinEnter,BufEnter * setl statusline=%!BufferListStatusline()
  autocmd WinLeave,BufLeave * setl statusline=%!InactiveStatusline()
  autocmd BufEnter,BufAdd,BufDelete,BufUnload,BufWritePost,WinEnter,WinLeave * redrawstatus
augroup END

" Return statusline string
function! BufferListStatusline()
  let maxwidth = winwidth(0) - s:StatuslineTailWidth() - 6 " chars: ' < ' + ' > '
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let names = []
  let ibegin = -1
  let iend = -1

  for i in range(len(buffers))
    let buf = buffers[i]
    let name = bufname(buf)
    let name = name == '' ? '[No Name]' : fnamemodify(name, ':t') " Use just the filename
    let name .= (getbufvar(buf, "&mod") ? '[+]' : '')
    if buf == bufnr('%')
      let name = '|' . name . '|'
    elseif buf == bufnr('#')
      let name .= '#'
    endif
    if buf == bufnr('%') || buf == bufnr('#')
      if ibegin < 0 && iend < 0
        let ibegin = i
      else
        let iend = i
      endif
    endif
    call add(names, name)
  endfor

  if iend < 0
    let iend = ibegin
  endif

  let output = ''
  let sep = '  '
  let total = 0
  let truncatedl = 0
  let truncatedr = 0

  " Include everything between current and alt buffer
  for i in range(ibegin, iend)
    let entry = names[i]
    let piece = (i == ibegin ? '' : sep) . entry
    let piece_len = strdisplaywidth(piece)
    if total + piece_len > maxwidth
      let truncatedr = 1
      break
    endif
    let output .= piece
    let total += piece_len
  endfor

  " Include other buffers alternating between left and right sides
  while !truncatedl && !truncatedr && (ibegin >= 0 || iend < len(names))
    let iend += 1
    if iend < len(names) && !truncatedr
      let entry = names[iend]
      let piece = sep . entry
      let piece_len = strdisplaywidth(piece)
      if total + piece_len > maxwidth
        let truncatedr = 1
      else
        let output .= piece
        let total += piece_len
      endif
    endif
    let ibegin -= 1
    if ibegin >= 0 && !truncatedl
      let entry = names[ibegin]
      let piece = entry . sep
      let piece_len = strdisplaywidth(piece)
      if total + piece_len > maxwidth
        let truncatedl = 1
      else
        let output = piece . output
        let total += piece_len
      endif
    endif
  endwhile

  if output != ''
    let output = (truncatedl ? '< ' : '') . output . (truncatedr ? ' >' : '')
  endif

  return $'{output} %= %y ≡ %l,%c%V %P '
endfunction

" Get width of all other artifacts
function s:StatuslineTailWidth()
  let filetype = &filetype != '' ? &filetype : (&readonly ? 'RO' : 'RW')
  let line = line('.')
  let col = col('.')
  let virtcol = virtcol('.')
  let percent = line('$') > 0 ? printf('%d%%%%', (line * 100) / line('$')) : '0%%'

  let text = $'  {filetype} ≡ {line},{col}-{virtcol} {percent}% '
  return strwidth(text)
endfunction

function! InactiveStatusline()
  return ' %t '
endfunction

" vim: shiftwidth=2 sts=2 expandtab
