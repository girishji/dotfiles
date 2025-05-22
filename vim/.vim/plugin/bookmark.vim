" vim: shiftwidth=2 sts=2 expandtab
"
" Use quickfix or location list to store bookmarks. Max 10 bookmarks.

let s:qflist = 1  " 1 for qflist and 0 for loclist

nnoremap <leader>m <cmd>call SaveBookmark()<CR>
nnoremap <leader>M <cmd>call ShowBookmarks()<CR>
nnoremap <leader>R <cmd>call RemoveCurrentBookmark()<CR>
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
  call filter(g:bookmarks, {_, v -> !(v.filename ==# l:entry.filename && v.lnum == l:entry.lnum)})

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
function s:SetBookmarks()
    if s:qflist
      call setqflist(g:bookmarks, 'r')
    else
      call setloclist(0, g:bookmarks, 'r')
    endif
endfunction

" ======================================================================
function s:GetBookmarks(what)
    if s:qflist
      return getqflist(a:what)
    else
      return getloclist(0, a:what)
    endif
endfunction

" ======================================================================
function! s:EnsureLoclistUpdated()
  let l:curr = s:GetBookmarks({'items': 1}).items
  if len(l:curr) != len(g:bookmarks)
    call s:SetBookmarks()
    return
  endif

  for i in range(len(l:curr))
    let l:curr_fname = fnamemodify(bufname(l:curr[i].bufnr), ':p')
    let l:bookmark_fname = fnamemodify(g:bookmarks[i].filename, ':p')

    if l:curr_fname !=# l:bookmark_fname
          \ || l:curr[i].lnum != g:bookmarks[i].lnum
          \ || l:curr[i].col != g:bookmarks[i].col
          \ || l:curr[i].text !=# g:bookmarks[i].text
      call s:SetBookmarks()
      return
    endif
  endfor
endfunction

" ======================================================================
function! ShowBookmarks()
  call s:EnsureLoclistUpdated()
  if s:qflist | copen | else | lopen | endif
endfunction

" ======================================================================
function! NextBookmark()
  if !exists('g:bookmarks') || empty(g:bookmarks)
    echo "No bookmarks"
    return
  endif

  call s:EnsureLoclistUpdated()
  let l:list = s:GetBookmarks({'all': 1})
  if s:qflist
    if l:list.idx >= l:list.size | cfirst | else | cnext | endif
  else
    if l:list.idx >= l:list.size | lfirst | else | lnext | endif
  endif
endfunction

" ======================================================================
function! PrevBookmark()
  if !exists('g:bookmarks') || empty(g:bookmarks)
    echo "No bookmarks"
    return
  endif

  call s:EnsureLoclistUpdated()
  let l:list = s:GetBookmarks({'all': 1})
  if s:qflist
    if l:list.idx <= 1 | clast | else | cprev | endif
  else
    if l:list.idx <= 1 | llast | else | lprev | endif
  endif
endfunction

" ======================================================================
function! RemoveCurrentBookmark()
  if !exists('g:bookmarks') || empty(g:bookmarks)
    echo "No bookmarks set"
    return
  endif

  let l:cur_bufname = fnamemodify(bufname('%'), ':p')
  let l:cur_lnum = line('.')
  let l:cur_col = col('.')

  let l:newlist = []
  let l:removed = 0

  for l:item in g:bookmarks
    let l:item_fname = fnamemodify(l:item.filename, ':p')
    if l:item_fname ==# l:cur_bufname && l:item.lnum == l:cur_lnum
      let l:removed = 1
      continue
    endif
    call add(l:newlist, l:item)
  endfor

  if l:removed
    let g:bookmarks = l:newlist
    call s:EnsureLoclistUpdated()
    echo "Bookmark removed"
  else
    echo "No matching bookmark found"
  endif
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
