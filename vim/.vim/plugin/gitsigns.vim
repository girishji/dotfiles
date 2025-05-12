" Insert signs in the sign column to indicate 'git diff'

augroup GitSignsAuto | autocmd!
  autocmd BufReadPost,BufWritePost * if &buftype ==# '' | call GitSigns() | endif
  " Checking buftype ensures it’s a real file buffer (not help, quickfix, etc.)
augroup END

" Define signs (once)
sign define GitAdded    text=+ texthl=LineNr
sign define GitRemoved  text=- texthl=LineNr
sign define GitChanged  text=~ texthl=LineNr

function s:IsGitFile()

  " Skip if buffer is not associated with a file (ex. [No Name])
  if expand('%') ==# '' || !filereadable(expand('%:p'))
    return 0
  endif

  " Check if file is in a Git repo
  call system('git rev-parse --is-inside-work-tree 2> /dev/null')
  if v:shell_error != 0
    return 0
  endif

  " Check if the file is tracked
  call system('git ls-files --error-unmatch ' . shellescape(expand('%:p')) . ' 2> /dev/null')
  if v:shell_error != 0
    return 0
  endif

  return 1

endfunction

function! GitSigns()

  if !s:IsGitFile()
    return
  endif

  " Clear existing signs
  silent! execute 'sign unplace * buffer=' . bufnr('%')

  " Run git diff
  let l:diff = systemlist('git diff --no-color -- ' . shellescape(expand('%:p')))

  let l:lnum = 0
  let l:id = 1000

  " Parse unified diff hunks like @@ -a,b +c,d @@
  for l:line in l:diff
    if l:line =~ '^@@'
      " Extract the +c,d range from the hunk header
      let l:m = matchlist(l:line, '^@@ -\d\+,\?\d* +\(\d\+\),\?\(\d*\) @@')
      if !empty(l:m)
        let l:start = str2nr(l:m[1])
        let l:count = len(l:m[2]) ? str2nr(l:m[2]) : 1
        let l:lnum = l:start - 1
      endif
    elseif l:line =~ '^+'
      let l:lnum += 1
      execute 'sign place ' . l:id . ' line=' . l:lnum . ' name=GitAdded buffer=' . bufnr('%')
      let l:id += 1
    elseif l:line =~ '^-'  " Removal is not shown in the new file, we skip placing
      " Could track separately if desired
    elseif l:line =~ '^ '
      let l:lnum += 1
    endif
  endfor
endfunction

" Keymaps

nnoremap ]h <cmd>call NextGitHunk()<CR>
nnoremap [h <cmd>call PrevGitHunk()<CR>

function! s:GitHunks()
  if !s:IsGitFile()
    return []
  endif

  let l:signs = sign_getplaced(bufnr('%'), {'group': '*', 'lnum': 0})[0].signs
  if empty(l:signs)
    echo "No Git signs"
    return []
  endif

  " Extract sorted list of line numbers
  let l:lines = sort(map(copy(l:signs), 'v:val.lnum'), {a, b -> str2nr(a) - str2nr(b)})

  " Collapse into hunks (groups of contiguous lines)
  let l:hunks = []
  let l:hunk = []

  for i in range(len(l:lines))
    if i == 0 || l:lines[i] == l:lines[i - 1] + 1
      call add(l:hunk, l:lines[i])
    else
      call add(l:hunks, l:hunk)
      let l:hunk = [l:lines[i]]
    endif
  endfor
  if !empty(l:hunk)
    call add(l:hunks, l:hunk)
  endif

  return l:hunks
endfunction

function! NextGitHunk()
  " Jump to the next hunk start after the current line
  let l:hunks = s:GitHunks()
  let l:current = line('.')
  for l:group in l:hunks
    if l:group[0] > l:current
      execute l:group[0]
      return
    endif
  endfor
  echo "No next hunk"
endfunction

function! PrevGitHunk()
  let l:hunks = s:GitHunks()
  let l:current = line('.')
  for l:group in reverse(l:hunks)
    if l:group[0] < l:current
      execute l:group[0]
      return
    endif
  endfor
  echo "No previous hunk"
endfunction

" vim: shiftwidth=2 sts=2 expandtab
