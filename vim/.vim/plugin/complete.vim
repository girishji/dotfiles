if has('gui_macvim')
  finish
endif

" ======================================================================
" Command-line autocomplete

autocmd CmdlineChanged [:/\?] call wildtrigger()
set wim=noselect:lastused,full wop=pum

cnoremap <up> <c-u><up>
cnoremap <down> <c-u><down>

autocmd CmdlineEnter : exec $'set ph={max([10, winheight(0) - 4])}'
" autocmd CmdlineEnter : set ph=12
autocmd CmdlineEnter [/\?] set ph=8
autocmd CmdlineLeave [:/\?] set ph&

" ----------------------------------------------------------------------
" Fuzzy find file

nnoremap <leader><space> :<c-r>=execute('let g:fzfind_root="."')\|''<cr>Find<space>
nnoremap <leader>fv :<c-r>=execute($'let g:fzfind_root="{expand('$HOME')}/.vim"')\|''<cr>Find<space>
nnoremap <leader>fV :<c-r>=execute($'let g:fzfind_root="{expand('$VIMRUNTIME')}"')\|''<cr>Find<space>

command! -nargs=* -complete=customlist,<SID>FuzzyFind Find exec $'edit! {s:selected}'

func s:FuzzyFind(cmdarg, cmdline, cursorpos)
  if s:allfiles == []
    let s:allfiles = systemlist($'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.sw?" \) -type f -follow')
  endif
  return a:cmdarg == '' ? s:allfiles : matchfuzzy(s:allfiles, a:cmdarg)
endfunc

let s:allfiles = []
autocmd CmdlineEnter : let s:allfiles = []

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
      \ if getcmdline() =~ '^\s*\%(Grep\|Find\)\s' && get(cmdcomplete_info(), 'matches', []) != [] |
      \   let s:info = cmdcomplete_info() |
      \   let s:selected = s:info.selected != -1 ? s:info.matches[s:info.selected] : s:info.matches[0] |
      \   call setcmdline(s:info.cmdline_orig) |
      \ endif

" ======================================================================
" Insert mode autocomplete
" Note: Do not set 'infercase' -- when typing all-caps it spams.
"   C omnifunc (ccomplete#Complete) needs tags file (:h ft-c-omni)

set autocomplete
set cpt=.^5,w^5,b^5,u^5
set cot=popup cpp=highlight:Normal

" ^X^F completes filename
set cot+=menuone,noselect

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
