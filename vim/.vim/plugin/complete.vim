if has('gui_macvim')
  finish
endif

" Command-line autocomplete
" --------------------------

autocmd CmdlineChanged [:/?] call wildtrigger()
set wim=noselect:lastused,full wop=pum

cnoremap <up> <c-u><up>
cnoremap <down> <c-u><down>

autocmd CmdlineEnter : exec $'set ph={max([10, winheight(0) - 4])}'
autocmd CmdlineEnter [/?] set ph=8
autocmd CmdlineLeave [:/?] set ph&

" Fuzzy find file
" --------------------------

nnoremap <leader><space> :<c-r>=execute('let g:fzfind_root="."')\|''<cr>find<space>
nnoremap <leader>fv :<c-r>=execute($'let g:fzfind_root="{expand('$HOME')}/.vim"')\|''<cr>find<space>
nnoremap <leader>fV :<c-r>=execute($'let g:fzfind_root="{expand('$VIMRUNTIME')}"')\|''<cr>find<space>

set findfunc=FuzzyFind

func FuzzyFind(cmdarg, _)
  if s:allfiles == []
    let s:allfiles = systemlist($'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.sw?" \) -type f -follow')
  endif
  return a:cmdarg == '' ? s:allfiles : matchfuzzy(s:allfiles, a:cmdarg)
endfunc

let s:allfiles = []
autocmd CmdlineEnter : let s:allfiles = []

" autocmd CmdlineLeavePre :
"       \ if getcmdline() =~ '^\s*fin\%[d]\s' && get(cmdcomplete_info(), 'matches', []) != []
"       \   && cmdcomplete_info().selected == -1 |
"       \     call setcmdline($'find {cmdcomplete_info().matches[0]}') |
"       \ endif

autocmd CmdlineLeavePre :
      \ if getcmdline() =~ '^\s*Find\s' && get(cmdcomplete_info(), 'matches', []) != [] |
      \   let s:info = cmdcomplete_info() |
      \   let s:selected = s:info.selected != -1 ? s:info.matches[s:info.selected] : s:info.matches[0] |
      \   call setcmdline(s:info.cmdline_orig) |
      \ endif

" Buffer
" --------------------------

nnoremap <leader><bs> :buffer<space>

autocmd CmdlineLeavePre :
      \ if getcmdline() =~ '^\s*b\%[uffer]\s' && get(cmdcomplete_info(), 'matches', []) != []
      \   && cmdcomplete_info().selected == -1 |
      \     call setcmdline($'buffer {cmdcomplete_info().matches[0]}') |
      \ endif

" Live grep
" --------------------------

nnoremap <leader>g :Grep<space>
nnoremap <leader>G :Grep <c-r>=expand("<cword>")<cr>

command! -nargs=+ -complete=customlist,GrepComplete Grep call VisitFile()

func GrepComplete(arglead, cmdline, cursorpos)
  let l:cmd = $'ggrep -REIHns "{a:arglead}" --exclude-dir=.git --exclude=".*" --exclude="tags" --exclude="*.sw?"'
  let s:selected = ''
  return len(a:arglead) > 1 ? systemlist(l:cmd) : [] " Trigger after 2 chars
endfunc

func VisitFile()
  if (s:selected != '')
    let l:item = getqflist(#{lines: [s:selected]}).items[0]
    if l:item->has_key('bufnr')
      let l:pos = l:item.vcol > 0 ? 'setcharpos' : 'setpos'
      exec $':b +call\ {l:pos}(".",\ [0,\ {l:item.lnum},\ {l:item.col},\ 0]) {l:item.bufnr}'
      call setbufvar(l:item.bufnr, '&buflisted', 1)
    endif
  endif
endfunc

autocmd CmdlineLeavePre :
      \ if getcmdline() =~ '^\s*Grep\s' && get(cmdcomplete_info(), 'matches', []) != [] |
      \   let s:info = cmdcomplete_info() |
      \   let s:selected = s:info.selected != -1 ? s:info.matches[s:info.selected] : s:info.matches[0] |
      \   call setcmdline(s:info.cmdline_orig) |
      \ endif

" ======================================================================
" Insert mode autocomplete
" Note: Do not set 'infercase' -- when typing all-caps it spams.
"   C omnifunc (ccomplete#Complete) needs tags file (:h ft-c-omni)
set autocomplete
set cpt=.^5,o^5,w^5,b^5,u^5
set cot=popup cpp=highlight:Normal

" Abbrev Completor
" --------------------------
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
