vim9script

if has('gui_macvim')
  finish
endif

# ---------------------------
# Insert Mode Auto-completion
# ---------------------------
# XXX 'menu' has a problem: if only 1 candidate, it completes on <c-n>, then
# <c-n> gets sent again due to event, and it reverts (the completion list in Vim
# has 2 items, one is typed text and another is candidate). these two alternate
# in a loop. Use 'menuone'.
#
# set cot=menuone,popup,noselect,nearest cpt-=t,i
set cot=menuone,popup,noselect,nearest cpt=.^5,w^5,b^5,u^5
autocmd TextChangedI * InsComplete()
def InsComplete()
  if getcharstr(1) == '' && getline('.')->strpart(0, col('.') - 1) =~ '\k$'
    # Suppress event caused by <c-n> if completion candidates not found
    SkipTextChangedI()
    feedkeys("\<c-n>", "n")
  endif
enddef
inoremap <silent> <c-e> <c-r>=<SID>SkipTextChangedI()<cr><c-e>
inoremap <silent> <c-y> <c-r>=<SID>SkipTextChangedI()<cr><c-y>
def SkipTextChangedI(): string
  set eventignore+=TextChangedI  # Suppress next event caused by <c-e> (or <c-n> when no matches found)
  timer_start(1, (_) => {
    set eventignore-=TextChangedI
  })
  return ''
enddef
inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
# inoremap <silent><expr> <cr> pumvisible() ? "\<c-r>=<SID>SkipTextChangedI()\<cr>\<c-y>" : "\<cr>"

# NOTE: <c-y> dismisses pum but keeps inserted item, use <c-e> to cancel.

# --------------------------
# Abbrev Completor
# --------------------------
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

# set cpt+=Ffunction("g:AbbrevCompletor"\\,\ [5])^5
  # def! g:AbbrevCompletor(maxitems: number, findstart: number, base: string): any
  # var T = items->empty() ? v:none :
  #     items->sort((v1, v2) => v1.word < v2.word ? -1 : v1.word ==# v2.word ? 0 : 1)->slice(0, maxitems)
  # return {words: T, refresh: 'always'}

# --------------------------
# Cmdline auto-completion
# --------------------------
set wim=noselect:lastused,full wop=pum,tagfile wcm=<C-@> wmnu

# NOTE: Using timer_start causes 'cmdheight' to jump +1 on first ':' attempt (vim bug)
# autocmd CmdlineChanged : timer_start(0, function(CmdComplete, [getcmdline()]))
# def CmdComplete(cur_cmdline: string, timer: number)
# autocmd CmdlineChanged : CmdComplete()

autocmd CmdlineChanged [:/?] CmdComplete()
def CmdComplete()
  var [cmdline, curpos] = [getcmdline(), getcmdpos()]
  var trigger = '\%(\w\|[*/:.-]\)$'
  var exclude = expand('<afile>') == ':' ? '^\%(\d\|,\|+\|-\)\+$' : ''  # Skip numeric range
  if getchar(1, {number: true}) == 0  # Typehead is empty (no more pasted input)
      && !wildmenumode() && curpos == cmdline->len() + 1
      && cmdline =~ trigger && cmdline !~ exclude
    SkipCmdlineChanged()  # Suppress redundant completion attempts
    feedkeys("\<C-@>", "t")
    # NOTE: Using the 'g' flag in substitute() prevents Vim from inserting
    #   <C-@> when typing quickly with no completion items available.
    # Remove <C-@> that get inserted when no items are available
    timer_start(0, (_) => getcmdline()->substitute('\%x00', '', 'ge')->setcmdline())
  endif
enddef
def SkipCmdlineChanged(key = ''): string
  set ei+=CmdlineChanged
  timer_start(0, (_) => execute('set ei-=CmdlineChanged'))
  return key == '' ? '' : ((wildmenumode() ? "\<c-e>" : '') .. key)
enddef
# Optional
cnoremap <expr> <up> SkipCmdlineChanged("\<up>")
cnoremap <expr> <down> SkipCmdlineChanged("\<down>")
autocmd CmdlineEnter : set bo+=error | exec $'set ph={max([10, winheight(0) - 4])}'
autocmd CmdlineLeave : set bo-=error ph&
autocmd CmdlineEnter [/?] set ph=8
autocmd CmdlineLeave [/?] set ph&
# autocmd CmdlineEnter /,\? setcmdline('\<') | set ph=8
# autocmd CmdlineEnter /,\? setcmdline('\<') | set wop-=pum
# autocmd CmdlineEnter /,\? set wop-=pum
# autocmd CmdlineLeave /,\? set wop+=pum

# Note:
# does not complete if not at end of line
# say there are space chars at end, if you make substitute replace all (not just
#  end) and use cmdline->trim(' ', 2)->len() + 1, then cursor will jump to end
#  after removing ^@ (past the trailing spaces), not desirable. so, better to
#  not support spaces at end
# can use substitute('\%x00', ...) to replace inside line, but cursor jumps to
#   end. may fix this using timer_start with setcmdpos or feedkeys

# --------------------------
# Preserve history completion and select first item by default
# --------------------------
var selected_match = null_string
autocmd CmdlineLeavePre : SelectItem()
def SelectItem()
  selected_match = ''
  if getcmdline() =~ '^\s*\%(Grep\|Find\|Buffer\|FindSymbol\)\s'
    var info = cmdcomplete_info()
    # if info != {} && info.pum_visible && !info.matches->empty()
    if wildmenumode() && info != {} && !info.matches->empty()
      selected_match = info.selected != -1 ? info.matches[info.selected] : info.matches[0]
      setcmdline(info.cmdline_orig)
    endif
  endif
enddef

# --------------------------
# Fuzzy find file
# --------------------------
# nnoremap <leader><space> :Find<space><c-@>
# command! -nargs=* -complete=customlist,FuzzyFind Find execute(selected_match != '' ? $'edit {selected_match}' : '', 'silent')
command! -nargs=* -complete=customlist,FuzzyFind Find exec "edit" selected_match
var allfiles: list<string>
autocmd CmdlineEnter : allfiles = null_list
def FuzzyFind(arglead: string, _: string, _: number): list<string>
  if allfiles == null_list
    allfiles = systemlist($'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.swp" \) -type f -follow')
  endif
  return arglead == '' ? allfiles : allfiles->matchfuzzy(arglead)
enddef
nnoremap <leader><space> :<c-r>=execute('let fzfind_root="."')\|''<cr>Find<space><c-@>
nnoremap <leader>fv :<c-r>=execute('let fzfind_root="$HOME/.vim"')\|''<cr>Find<space><c-@>
nnoremap <leader>fV :<c-r>=execute('let fzfind_root="$VIMRUNTIME"')\|''<cr>Find<space><c-@>

# --------------------------
# Live grep
# --------------------------
nnoremap <leader>g :Grep<space>
nnoremap <leader>G :Grep <c-r>=expand("<cword>")<cr>
command! -nargs=+ -complete=customlist,GrepComplete Grep VisitFile()
def GrepComplete(arglead: string, cmdline: string, cursorpos: number): list<any>
  return arglead->len() > 1 ? systemlist($'ggrep -REIHns "{arglead}"' ..
    ' --exclude-dir=.git --exclude=".*" --exclude="tags" --exclude="*.swp"') : []
enddef
def VisitFile()
  if (selected_match != null_string)
    var qfitem = getqflist({lines: [selected_match]}).items[0]
    if qfitem->has_key('bufnr') && qfitem.lnum > 0
      var pos = qfitem.vcol > 0 ? 'setcharpos' : 'setpos'
      silent exec $':b +call\ {pos}(".",\ [0,\ {qfitem.lnum},\ {qfitem.col},\ 0]) {qfitem.bufnr}'
      setbufvar(qfitem.bufnr, '&buflisted', 1)
    endif
  endif
enddef

# --------------------------
# Fuzzy find buffer
# --------------------------
nnoremap <leader><bs> :Buffer <c-@>
command! -nargs=* -complete=customlist,FuzzyBuffer Buffer execute('b ' .. selected_match->matchstr('\d\+'))
def FuzzyBuffer(arglead: string, _: string, _: number): list<string>
  var bufs = execute('buffers', 'silent!')->split("\n")
  var altbuf = bufs->indexof((_, v) => v =~ '^\s*\d\+\s\+#')
  if altbuf != -1
    [bufs[0], bufs[altbuf]] = [bufs[altbuf], bufs[0]]
  endif
  return arglead == '' ? bufs : bufs->matchfuzzy(arglead)
enddef

# vim: shiftwidth=2 sts=2 expandtab
