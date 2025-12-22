" ------------------------------------------------------------
" Formatting
" ------------------------------------------------------------

if executable('black')
  let &l:formatprg = 'black -q - 2>/dev/null'
elseif executable('yapf')
  let &l:formatprg = 'yapf'
endif

if exists('g:loaded_lsp')
  set omnifunc=g:LspOmniFunc
  set cpt+=o
endif

setlocal foldignore=

let b:undo_ftplugin .= ' | setl foldignore< formatprg< | silent! autocmd! PythonAutoImport'

" Convince python that 'def' is a macro like C's #define
setlocal define=^\s*def
setlocal makeprg=python3\ %


" ------------------------------------------------------------
" Mappings
" ------------------------------------------------------------

nnoremap <buffer> <leader>vi :% !tidy-imports --replace-star-imports -r -p --quiet --black<CR>
nnoremap <buffer> <leader>p  :new \| exec 'nn <buffer> q :bd!' \| r !python3 #<CR>
nnoremap <buffer> <leader>P  :Ipython<CR>

let g:pyindent_open_paren = 'shiftwidth()'


" ------------------------------------------------------------
" Abbreviations
" ------------------------------------------------------------

iabbr <buffer> case_ match myval:
      \ <CR>case 10:
      \ <CR>pass
      \ <CR>case _:<Esc>3k_fm;i<C-R>=Eatchar()<CR>

iabbr <buffer> match_case_ match myval:
      \ <CR>case 10:
      \ <CR>pass
      \ <CR>case _:<Esc>3k_fm;i<C-R>=Eatchar()<CR>

iabbr <buffer> prerr; print(, file=stderr)<Esc>F,i<C-R>=Eatchar()<CR>
iabbr <buffer> p;     print()<C-O>i<C-R>=Eatchar()<CR>
iabbr <buffer> pr;    print(, end="\n")<C-O>F,<C-R>=Eatchar()<CR>
iabbr <buffer> pr_;   print(, end="")<C-O>F,<C-R>=Eatchar()<CR>

iabbr <buffer> enum; Color = Enum('Color', ['RED', 'GRN'])<Esc>_fC<C-R>=Eatchar()<CR>
iabbr <buffer> tuple_  Point = namedtuple('Point', 'x y')<Esc>_<C-R>=Eatchar()<CR>
iabbr <buffer> tuple__ Point = namedtuple('Point', ('x', 'y'), defaults=(None,) * 2)<Esc>_<C-R>=Eatchar()<CR>

iabbr <buffer> def_  def ():<CR>"""."""<Esc>-f(i<C-R>=Eatchar()<CR>
iabbr <buffer> def__ def ():<C-O>o'''<CR>>>> print()<CR><CR>'''<Esc>4k_f(i<C-R>=Eatchar()<CR>

iabbr <buffer> python3# #!/usr/bin/env python3<Esc><C-R>=Eatchar()<CR>


" ------------------------------------------------------------
" Leetcode helpers
" ------------------------------------------------------------

function! s:GetSurroundingFn() abort
  let fpat = '\vdef\s+\zs\k+'
  let lnum = search(fpat, 'nb')
  if lnum > 0
    let fname = matchstr(getline(lnum), fpat) . '()'
    let cpat = '\vclass\s+\zs\k+'
    let lnum = search(cpat, 'nb')
    if lnum > 0
      return matchstr(getline(lnum), cpat) . '().' . fname
    endif
    return fname
  endif
  return ''
endfunction

iabbr <buffer> '''_ '''
      \ <CR>>>> print(<C-R>=<SID>GetSurroundingFn()<CR>)
      \ <CR>'''<Esc>ggOfrom sys import stderr<Esc>Go<C-U><Esc>o<Esc>
      \ :normal imain__2<CR>
      \ ?>>> print<CR>:nohl<CR>g_hi<C-R>=Eatchar()<CR>

iabbr <buffer> """ """."""<C-O>3h<C-R>=Eatchar()<CR>


" ------------------------------------------------------------
" Ipython reuse
" ------------------------------------------------------------

function! s:Ipython() abort
  let listed = getbufinfo({'buflisted': 1})
  for buf in listed
    if buf.name =~? 'ipython'
      if bufwinnr(buf.bufnr) == -1
        execute 'sbuffer ' . buf.bufnr
      endif
      return
    endif
  endfor
  term ++close ++kill=term ipython3 --no-confirm-exit --colors=Linux
endfunction

command! Ipython call s:Ipython()


" ------------------------------------------------------------
" Navigation / symbols
" ------------------------------------------------------------

if exists('g:loaded_scope')

  function! s:Things() abort
    let items = []
    for nr in range(1, line('$'))
      let l = getline(nr)
      if l =~ '\(^\|\s\)\(def\|class\) \k\+(' || l =~ 'if __name__ == "__main__":'
        call add(items, {'text': l . ' (' . nr . ')', 'linenr': nr})
      endif
    endfor

    call popup_filter_menu#new(
          \ 'Py Things',
          \ items,
          \ function('s:ThingsSelect'),
          \ function('s:ThingsSetup')
          \ )
  endfunction

  function! s:ThingsSelect(res, key) abort
    execute ':' . a:res.linenr
    normal! zz
  endfunction

  function! s:ThingsSetup(winid, _) abort
    call win_execute(a:winid, "syn match FilterMenuLineNr '(\\d\\+)$'")
    hi def link FilterMenuLineNr Comment
  endfunction

elseif exists('g:loaded_vimsuggest')
  nnoremap <buffer> <leader>/ :VSGlobal \v(^\|\s)(def\|class).{-}<CR>
else

  function! s:Definitions() abort
    let items = []
    for nr in range(1, line('$'))
      let name = matchstr(getline(nr), '\(^\|\s\)\(def\|class\)\s\+\zs\k\+\ze(')
      if !empty(name)
        call add(items, {'text': name, 'lnum': nr})
      endif
    endfor
    return items
  endfunction

  function! s:DoCommand(arg) abort
    let items = empty(a:arg)
          \ ? s:Definitions()
          \ : matchfuzzy(s:Definitions(), a:arg, {'key': 'text'})
    if !empty(items)
      execute ':' . items[0].lnum
      normal! zz
    endif
  endfunction

  function! s:Completor(A, L, P) abort
    let items = empty(a:A)
          \ ? s:Definitions()
          \ : matchfuzzy(s:Definitions(), a:A, {'key': 'text'})
    return map(copy(items), 'v:val.text')
  endfunction

  command! -buffer -nargs=* -complete=customlist,s:Completor PyGoTo call s:DoCommand(<q-args>)
  nnoremap <buffer> <space>/ :PyGoTo<Space>

endif


if exists(':LspDocumentSymbol') == 2
  nnoremap <buffer> <space>z :LspDocumentSymbol<CR>
elseif exists('g:loaded_scope')
  nnoremap <buffer> <space>/ :call <SID>Things()<CR>
endif
