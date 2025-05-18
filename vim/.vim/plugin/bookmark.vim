" vim: shiftwidth=2 sts=2 expandtab
"
" Use location list to bookmark lines. Max 10 bookmarks.

nnoremap <leader>m <cmd>call SaveBookmark()<CR>
nnoremap <leader>M <cmd>call ShowBookmarks()<CR>
nnoremap <silent> ]m <cmd>call NextBookmark()<CR>
nnoremap <silent> [m <cmd>call PrevBookmark()<CR>
nnoremap <silent> <leader>] <cmd>call NextBookmark()<CR>
nnoremap <silent> <leader>[ <cmd>call PrevBookmark()<CR>

let g:bookmark_file = expand('~/.vim-bookmarks.vim')
let g:bookmarks = []

" ======================================================================
function! SaveBookmark()
  let l:fname = expand('%:p')
  if empty(l:fname) || !filereadable(l:fname)
    echo "Not a valid file"
    return
  endif

  let l:entry = {
        \ 'filename': l:fname,
        \ 'lnum': line('.'),
        \ 'col': col('.'),
        \ 'text': getline('.')
        \ }

  " Remove existing identical entry
  call filter(g:bookmarks, {_, v -> !(v.filename ==# l:entry.filename
    && v.lnum == l:entry.lnum)})

  " Insert new entry at the top
  call insert(g:bookmarks, l:entry, 0)

  " Keep only last 10 entries
  if len(g:bookmarks) > 10
    call remove(g:bookmarks, 10, -1)
  endif

  " Write to file
  try
    call writefile(map(copy(g:bookmarks), 'string(v:val)'), g:bookmark_file)
  catch
    echoerr "Failed to save bookmarks"
  endtry
  echo "Bookmark saved"
endfunction

" ======================================================================
function! s:EnsureLoclistUpdated()
  let l:curr = getloclist(0, {'items': 1}).items
  if len(l:curr) != len(g:bookmarks)
    call setloclist(0, g:bookmarks, 'r')
    return
  endif

  for i in range(len(l:curr))
    let l:curr_fname = fnamemodify(bufname(l:curr[i].bufnr), ':p')
    let l:bookmark_fname = fnamemodify(g:bookmarks[i].filename, ':p')

    if l:curr_fname !=# l:bookmark_fname
          \ || l:curr[i].lnum != g:bookmarks[i].lnum
          \ || l:curr[i].col != g:bookmarks[i].col
          \ || l:curr[i].text !=# g:bookmarks[i].text
      echom l:curr[i] g:bookmarks[i]
      call setloclist(0, g:bookmarks, 'r')
      return
    endif
  endfor
endfunction

" ======================================================================
function! ShowBookmarks()
  call s:EnsureLoclistUpdated()
  lopen
endfunction

" ======================================================================
function! NextBookmark()
  if empty(g:bookmarks)
    echo "No bookmarks"
    return
  endif

  call s:EnsureLoclistUpdated()
  let l:list = getloclist(0, {'all': 1})
  if l:list.idx >= l:list.size | lfirst | else | lnext | endif
endfunction

" ======================================================================
function! PrevBookmark()
  if empty(g:bookmarks)
    echo "No bookmarks"
    return
  endif

  call s:EnsureLoclistUpdated()
  let l:list = getloclist(0, {'all': 1})
  if l:list.idx <= 1 | llast | else | lprev | endif
endfunction

" ======================================================================
function! LoadBookmarksFromFile()
  if filereadable(g:bookmark_file)
    let l:lines = readfile(g:bookmark_file)
    let g:bookmarks = map(l:lines, 'eval(v:val)')
  endif
endfunction

" Load automatically at startup (optional)
augroup bookmarks
  autocmd!
  autocmd VimEnter * call LoadBookmarksFromFile()
augroup END
