if has('gui_macvim')
  finish
endif

" ======================================================================
" Command-line autocomplete
"
autocmd CmdlineChanged [:/\?] call wildtrigger()
set wim=noselect:lastused,full wop=pum

cnoremap <expr> <up>   wildmenumode() ? "\<c-e>\<up>"   : "\<up>"
cnoremap <expr> <down> wildmenumode() ? "\<c-e>\<down>" : "\<down>"

autocmd CmdlineEnter : exec $'set ph={max([10, winheight(0) - 4])}'
autocmd CmdlineEnter [/\?] set ph=8
autocmd CmdlineLeave [:/\?] set ph&

if !has('nvim')
  autocmd CmdlineEnter [:/\?] set pb=double,margin,shadow
  autocmd CmdlineLeave [:/\?] set pb=shadow
endif

hi PmenuBorder ctermfg=10 ctermbg=6

" ----------------------------------------------------------------------
" Fuzzy find file

nnoremap <leader><space> :<c-r>=execute('let g:fzfind_root="."')\|''<cr>Find<space>
nnoremap <leader>fv :<c-r>=execute($'let g:fzfind_root="{expand('$HOME')}/.vim"')\|''<cr>Find<space>
nnoremap <leader>fV :<c-r>=execute($'let g:fzfind_root="{expand('$VIMRUNTIME')}"')\|''<cr>Find<space>

command! -nargs=* -complete=customlist,<SID>FuzzyFind Find exec $'edit! {s:selected}'

func s:FuzzyFind(cmdarg, cmdline, cursorpos)
  if s:files_cache == []
    let s:files_cache = systemlist(
          \ $'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.sw?" \) -type f -follow')
  endif
  return a:cmdarg == '' ? s:files_cache : matchfuzzy(s:files_cache, a:cmdarg)
endfunc

let s:files_cache = []
autocmd CmdlineEnter : let s:files_cache = []

" ----------------------------------------------------------------------
" Buffer

nnoremap <leader><bs> :buffer<space>

autocmd CmdlineLeavePre :
      \ if getcmdline() =~ '^\s*b\%[uffer]\s' && get(cmdcomplete_info(), 'matches', []) != []
      \   && cmdcomplete_info().selected == -1 |
      \     call setcmdline($'buffer {cmdcomplete_info().matches[0]}') |
      \ endif

" ----------------------------------------------------------------------
" Live grep

nnoremap <leader>g :Grep<space>
nnoremap <leader>G :Grep <c-r>=expand("<cword>")<cr>

command! -nargs=+ -complete=customlist,<SID>GrepComplete Grep call <SID>VisitFile()

func s:GrepComplete(arglead, cmdline, cursorpos)
  let l:cmd = $'ggrep -REIHns "{a:arglead}" --exclude-dir=.git --exclude=".*" --exclude="tags" --exclude="*.sw?"'
  return len(a:arglead) > 1 ? systemlist(l:cmd) : [] " Trigger after 2 chars
endfunc

func s:VisitFile()
  let l:item = getqflist(#{lines: [s:selected]}).items[0]
  exec $':b +call\ setpos(".",\ [0,\ {l:item.lnum},\ {l:item.col},\ 0]) {l:item.bufnr}'
  call setbufvar(l:item.bufnr, '&buflisted', 1)
endfunc

autocmd CmdlineLeavePre :
      \ if getcmdline() =~ '^\s*\%(Grep\|Find\)\s' && get(cmdcomplete_info(), 'matches', []) != [] |
      \   let s:info = cmdcomplete_info() |
      \   let s:selected = s:info.selected != -1 ? s:info.matches[s:info.selected] : s:info.matches[0] |
      \   call setcmdline(s:info.cmdline_orig) |
      \ endif

" ======================================================================
" Insert mode autocomplete
" Note:
"   - Do not set 'infercase' -- when typing all-caps it spams.
"   - Omnifunc (ccomplete#Complete) for C lang needs tags file (:h ft-c-omni)

set autocomplete
set cpt=.^5,w^5,b^5,u^5
" set cot=popup,longest
set cot=popup
if !has('nvim')
  if exists('&pumborder')
    set pb=shadow
  endif
  set cpp=highlight:Normal
endif

" func SmartTab()
"   if &cot !~ 'longest\|preinsert' || !exists("*preinserted") || !preinserted()
"     return pumvisible() ? "\<c-n>" : "\<tab>"
"   endif
"   let info = complete_info()
"   let items = info->has_key('matches') ? info.matches : info.items
"   " send cursor to the end of XCxxxX (only one char after preinserted text) always ('x' is preinserted)
"   if items[0].word[:-2] =~ $'\C{info.preinserted_text}$'
"     return "\<c-n>"
"   endif
"   " send cursor to the end of XCxxxXXX (when first item matches exactly)
"   let postfix = getline('.')->strpart(col('.') - 1)->matchstr('^\k\+')
"   if items[0].word =~ $'\C{postfix}$'
"     let hops = postfix->len() - info.preinserted_text->len()
"     return "\<c-y>" . repeat("\<right>", hops)
"   endif
"   return "\<c-y>"
" endfunc

" inoremap <silent><expr> <tab> SmartTab()
" inoremap <silent><expr> <tab> preinserted() ? "\<c-y>" : pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <silent><expr> <PageDown> exists("*preinserted") && preinserted() ? "\<c-y>" : "\<PageDown>"

hi link PreInsert LineNr

" For manual completion (ex. ^X^F completes filename)
" set cot+=menuone,noselect

" ----------------------------------------------------------------------
" Abbrev Completor

" Add to complete functions
set cpt+=FAbbrevCompletor

" Define the completion function
function! AbbrevCompletor(findstart, base) abort
  if a:findstart
    " Get the prefix before the cursor
    let prefix = matchstr(getline('.'), '\S\+$')
    if empty(prefix)
      return -2
    endif
    return col('.') - len(prefix) - 1
  endif

  " Get all insert-mode abbreviations
  let lines = execute('ia', 'silent!')
  if lines =~? 'No abbreviation found'
    return v:none
  endif

  let items = []
  for line in split(lines, "\n")
    let m = matchlist(line, '\v^i\s+\zs(\S+)\s+(.*)$')
    if len(m) > 2 && stridx(m[1], a:base) == 0
      call add(items, {'word': m[1], 'menu': 'abbr', 'info': m[2], 'dup': 1})
    endif
  endfor

  " Sort items by word
  if !empty(items)
    call sort(items, {a,b->a.word < b.word ? -1 : a.word > b.word ? 1 : 0})
    return items
  endif

  return v:none
endfunction

" set cpt+=FAbbrevCompletor
" def! g:AbbrevCompletor(findstart: number, base: string): any
"   if findstart > 0
"     var prefix = getline('.')->strpart(0, col('.') - 1)->matchstr('\S\+$')
"     if prefix->empty()
"       return -2
"     endif
"     return col('.') - prefix->len() - 1
"   endif
"   var lines = execute('ia', 'silent!')
"   if lines =~? gettext('No abbreviation found')
"     return v:none  # Suppresses warning message
"   endif
"   var items = []
"   for line in lines->split("\n")
"     var m = line->matchlist('\v^i\s+\zs(\S+)\s+(.*)$')
"     if m->len() > 2 && m[1]->stridx(base) == 0
"       items->add({ word: m[1], menu: 'abbr', info: m[2], dup: 1 })
"     endif
"     items->sort()
"   endfor
"   return items->empty() ? v:none : items
" enddef

" vim: shiftwidth=2 sts=2 expandtab
