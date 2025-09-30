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

autocmd CmdlineEnter [/\?]  set pumheight=8
autocmd CmdlineLeave [/\?]  set pumheight&

autocmd CmdlineEnter : exec $'set ph={max([10, winheight(0) - 4])}'
autocmd CmdlineEnter [/\?] set ph=8
autocmd CmdlineLeave [:/\?] set ph&

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
set cot=popup,longest cpp=highlight:Normal
" set pb=double,shadow,margin

" Move cursor to the end of XCxxxX (always) and XCxxxX+ (when only one item is present),
" where x is preinserted char and C is cursor. Needs "longest" in 'cot'.
func AcceptPreinsert()
  let word = getline('.')->strpart(0, col('.') - 1)->matchstr('^\S\+')
  let info = complete_info()
  return exists("*preinserted") && preinserted() && info.selected == -1
        \ && ((info->has_key('matches') && info.matches->len() > 1 && info.matches[0].word[:-2] != word)
        \ || (info.items->len() > 1 && info.items[0].word[:-2] != word))
endfunc

inoremap <silent><expr> <tab> AcceptPreinsert() ? "\<c-y>" : pumvisible() ? "\<c-n>" : "\<tab>"
" inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <silent><expr> <PageDown> exists("*preinserted") && preinserted() ? "\<c-y>" : "\<PageDown>"

hi link PreInsert LineNr

" For manual completion (ex. ^X^F completes filename)
" set cot+=menuone,noselect

" ----------------------------------------------------------------------
" Abbrev Completor

set cpt+=FAbbrevCompletor
def! g:AbbrevCompletor(findstart: number, base: string): any
  if findstart > 0
    var prefix = getline('.')->strpart(0, col('.') - 1)->matchstr('\S\+$')
    if prefix->empty()
      return -2
    endif
    return col('.') - prefix->len() - 1
  endif
  var lines = execute('ia', 'silent!')
  if lines =~? gettext('No abbreviation found')
    return v:none  # Suppresses warning message
  endif
  var items = []
  for line in lines->split("\n")
    var m = line->matchlist('\v^i\s+\zs(\S+)\s+(.*)$')
    if m->len() > 2 && m[1]->stridx(base) == 0
      items->add({ word: m[1], menu: 'abbr', info: m[2], dup: 1 })
    endif
  endfor
  return items->empty() ? v:none : items
enddef

" vim: shiftwidth=2 sts=2 expandtab
