" ------------------------------------------------------------
" Detect whether cursor is inside a markdown code block
" ------------------------------------------------------------

function! s:InCode(_) abort
  return synIDattr(synID(line('.'), col('.') - 1, 1), 'name') =~? 'markdownCodeBlock'
endfunction


iabbrev <buffer><expr> nn <SID>InCode('nn') ? 'NOTE:' : 'nn'


" ------------------------------------------------------------
" Insert '\' in front of <foo> when not in code block
" ------------------------------------------------------------

command! EscapeTags call s:EscapeTags()

function! s:EscapeTags() abort
  for lnum in range(1, line('$'))
    let groups = map(synstack(lnum, 1), 'synIDattr(v:val, "name")')
    if index(groups, 'markdownCodeBlock') == -1
      let line = getline(lnum)
      if line =~ '[^\\]<'
        call setline(
              \ lnum,
              \ substitute(line, '\([^\\]\)\(<[a-zA-Z]\)', '\1\\\2', 'g')
              \ )
      endif
    endif
  endfor
endfunction
