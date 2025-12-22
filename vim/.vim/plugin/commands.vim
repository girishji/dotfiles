" ------------------------------------------------------------
" Find highlight group under cursor
" ------------------------------------------------------------

command! HighlightGroupUnderCursor call s:HighlightGroupUnderCursor()

function! s:HighlightGroupUnderCursor() abort
  if exists('*synstack')
    for id in synstack(line('.'), col('.'))
      let grp = synIDattr(id, 'name')
      echo 'Group:' grp
      let g = grp
      while 1
        let out = execute('hi ' . g)
        let linksto = matchstr(out, 'links to \zs\S\+')
        if empty(linksto)
          execute 'verbose hi ' . g
          break
        else
          echo '->' linksto
          let g = linksto
        endif
      endwhile
    endfor
  endif
endfunction

" ------------------------------------------------------------
" Open files in ~/help folder using :hf
" ------------------------------------------------------------

command! -nargs=1 -complete=custom,s:HelpCompletor HelpFile call s:OpenHelpFile(<f-args>)

function! s:HelpCompletor(A, L, P) abort
  let dir = expand('~/help')
  if !isdirectory(dir)
    return ''
  endif

  let files = []
  for f in readdir(dir)
    if f !~# '^\.' && !isdirectory(dir . '/' . f)
      call add(files, f)
    endif
  endfor
  return join(files, "\n")
endfunction


function! s:OpenHelpFile(prefix) abort
  let fname = expand('~/help/' . a:prefix)

  if filereadable(fname)
    execute 'edit ' . fname
  else
    let paths = getcompletion(fname, 'file')
    if len(paths) == 1
      execute 'edit ' . paths[0]
    endif
  endif
endfunction


function! s:CanExpandHF() abort
  if getcmdtype() ==# ':'
    let context = strpart(getcmdline(), 0, getcmdpos() - 1)
    if context ==# 'hf'
      return 1
    endif
  endif
  return 0
endfunction

cabbrev <expr> hf <SID>CanExpandHF() ? 'HelpFile' : 'hf'


" ------------------------------------------------------------
" TrailingWhitespaceStrip
" ------------------------------------------------------------

command! TrailingWhitespaceStrip call s:TrailingWhitespaceStrip()
command! StripWhitespace         call s:TrailingWhitespaceStrip()

function! s:TrailingWhitespaceStrip() abort
  if !&binary && &filetype !=# 'diff'
    normal! mz
    normal! Hmy
    %s/\s\+$//e
    normal! 'yz
    normal! `z
  endif
endfunction


" ------------------------------------------------------------
" :<range>Align [char]
" ------------------------------------------------------------

command! -range -nargs=* Align call s:Align(<line1>, <line2>, <f-args>)

function! s:Align(line1, line2, ...) abort
  let delimit = a:0 ? a:1 : ''
  let sep = empty(delimit) ? '\s\+' : escape(delimit, '\') . '\+'

  let raw = getline(a:line1, a:line2)
  let words = map(copy(raw), 'split(v:val, sep)')
  let maxwords = max(map(copy(words), 'len(v:val)'))

  let maxcount = []
  for i in range(maxwords)
    let m = 0
    for line in words
      if i < len(line)
        let m = max([m, len(line[i])])
      endif
    endfor
    call add(maxcount, m)
  endfor

  let indent = map(copy(raw), 'matchstr(v:val, ''\s*\ze\S'')')

  for lnum in range(len(words))
    let lwords = words[lnum]
    let line = ''
    for j in range(max([0, len(lwords) - 1]))
      let pad = repeat(' ', maxcount[j] - len(lwords[j]) + 1)
      let line .= lwords[j] . pad
      if !empty(delimit)
        let line .= delimit . ' '
      endif
    endfor
    if !empty(lwords)
      let line .= lwords[-1]
    endif
    call setline(a:line1 + lnum, indent[lnum] . line)
  endfor
endfunction

" vim: shiftwidth=2 sts=2 expandtab
