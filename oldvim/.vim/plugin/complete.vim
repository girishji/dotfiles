vim9script

if has('gui_macvim')
  finish
endif

# ---------------------------
# Insert Mode Auto-completion
# ---------------------------
# set cot=menuone,popup,noselect,nearest cpt=.^5,w^5,b^5,u^5
# autocmd TextChangedI * InsComplete()
# def InsComplete()
#   if getcharstr(1) == '' && getline('.')->strpart(0, col('.') - 1) =~ '\k$'
#     # Suppress event caused by <c-n> if completion candidates not found
#     SkipTextChangedI()
#     feedkeys("\<c-n>", "nt")  # 't' is important
#   endif
# enddef
# def SkipTextChangedI(): string
#   set eventignore+=TextChangedI  # Suppress next event caused by <c-e> (or <c-n> when no matches found)
#   timer_start(1, (_) => {
#     set eventignore-=TextChangedI
#   })
#   return ''
# enddef
# inoremap <silent> <c-e> <c-r>=<SID>SkipTextChangedI()<cr><c-e>
# inoremap <silent> <c-y> <c-r>=<SID>SkipTextChangedI()<cr><c-y>

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

# --------------------------
# Cmdline auto-completion
# --------------------------
set wim=noselect:lastused,full wop=pum,tagfile wcm=<C-@> wmnu

autocmd CmdlineChanged [:/?] CmdComplete()

def CmdComplete()
  var [cmdline, curpos, cmdmode] = [getcmdline(), getcmdpos(), expand('<afile>') == ':']
  var trigger_char = '\%(\w\|[*/:.-]\)$'
  var not_trigger_char = '^\%(\d\|,\|+\|-\)\+$'  # Skip numeric range
  if getchar(1, {number: true}) == 0  # Typehead is empty (no more pasted input)
      && !wildmenumode() && curpos == cmdline->len() + 1
      && (!cmdmode || (cmdline =~ trigger_char && cmdline !~ not_trigger_char))
    # XXX: Here SkipCmdlineChangedEvent() does not help with live grep jittering
    # when no matches are found (call SkipCmdlineChangedEvent inside
    # GetCmdOutput() to fix that), but it helps with :s/ jittering.
    SkipCmdlineChangedEvent()  # Suppress redundant completion attempts
    feedkeys("\<C-@>", "nt")
    # NOTE: Using the 'g' flag in substitute() prevents Vim from inserting
    #   <C-@> when typing quickly with no completion items available.
    # Remove <C-@> that get inserted when no items are available
    timer_start(0, (_) => getcmdline()->substitute('\%x00', '', 'ge')->setcmdline())
  endif
enddef

def SkipCmdlineChangedEvent(): number
  set ei+=CmdlineChanged
  # If you increase time to say 300, live grep fails to get invoked second time
  # when 2 characters are typed quickly.
  timer_start(0, (_) => execute('set ei-=CmdlineChanged'))
  return wildmenumode()
enddef

# Optional
cnoremap <expr> <up> SkipCmdlineChangedEvent() ? "\<c-e>\<up>" : "\<up>"
cnoremap <expr> <down> SkipCmdlineChangedEvent() ? "\<c-e>\<down>" : "\<down>"

autocmd CmdlineEnter [:/?] set bo+=error | exec $'set ph={max([10, winheight(0) - 4])}'
autocmd CmdlineLeave [:/?] set bo-=error ph&
autocmd CmdlineEnter [/?] set ph=8

# autocmd CmdlineEnter /,\? set wop-=pum
# autocmd CmdlineLeave /,\? set wop+=pum

# Note:
# Using timer_start causes 'cmdheight' to jump +1 on first ':'
#   attempt (vim bug). Use getchar() instead.
# Does not complete if not at end of line, by design.
# say there are space chars at end, if you make substitute replace all (not just
#  end) and use cmdline->trim(' ', 2)->len() + 1, then cursor will jump to end
#  after removing ^@ (past the trailing spaces), not desirable. so, better to
#  not support spaces at end
# can use substitute('\%x00', ...) to replace inside line, but cursor jumps to
#   end. may fix this using timer_start with setcmdpos or feedkeys

# ----------------------------------------
# Start a time-limited job and get output of command
# ----------------------------------------
def GetCmdOutput(cmd: string, partial_response: bool): list<any>
  var items = []
  var done = false

  var job = job_start(cmd, {
    out_cb: (ch, str) => { # invoked when channel reads a line
      items->add(str)
    },
    close_cb: (ch) => { # invoked after command returns
      done = true
    },
  })
  # Blocking loop: wait until job is done
  var start_time = reltime()
  while !done
    sleep 2m
    # Do not fully hang Vim: allow messages, redrawing, and channel events
    var char_waiting = getchar(1, {number: true}) != 0
    if char_waiting || start_time->reltime()->reltimefloat() * 1000 > 500
      done = true
      items = char_waiting ? [] : partial_response ? items : []
      job->job_stop('kill')
    endif
  endwhile

  if items == []
    SkipCmdlineChangedEvent() # stops calling this fn in a loop when no items are found
  endif
  return items
enddef

# --------------------------
# Fuzzy find file
# --------------------------
nnoremap <leader><space> :<c-r>=execute('let fzfind_root="."')\|''<cr>Find<space><c-@>
nnoremap <leader>fv :<c-r>=execute($'let fzfind_root="{expand('$HOME')}/.vim"')\|''<cr>Find<space><c-@>
nnoremap <leader>fV :<c-r>=execute($'let fzfind_root="{expand('$VIMRUNTIME')}"')\|''<cr>Find<space><c-@>

command! -nargs=* -complete=customlist,FuzzyFind Find execute $'silent edit {selected_menu_item}'

var allfiles: list<string>

autocmd CmdlineEnter : allfiles = null_list

def FuzzyFind(arglead: string, _: string, _: number): list<string>
  if allfiles == null_list
    allfiles = systemlist($'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.sw?" \) -type f -follow')
    # allfiles = GetCmdOutput($'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.sw?" \) -type f -follow', false)
  endif
  return arglead == '' ? allfiles : allfiles->matchfuzzy(arglead)
enddef

# --------------------------
# Live grep
# --------------------------
nnoremap <leader>g :Grep<space>
nnoremap <leader>G :Grep <c-r>=expand("<cword>")<cr>

command! -nargs=+ -complete=customlist,GrepComplete Grep VisitFile()

def GrepComplete(arglead: string, cmdline: string, cursorpos: number): list<any>
  var cmd = $'ggrep -REIHns "{arglead}" --exclude-dir=.git --exclude=".*" --exclude="tags" --exclude="*.sw?"'
  return len(arglead) > 1 ? systemlist(cmd) : []
  # XXX: when typing very fast GetCmdOutput returns empty list
  # return arglead != null_string ? GetCmdOutput(cmd, true) : []
enddef

def VisitFile()
  if (selected_menu_item != null_string)
    var qfitem = getqflist({lines: [selected_menu_item]}).items[0]
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

command! -nargs=* -complete=customlist,FuzzyBuffer Buffer execute 'b' selected_menu_item->matchstr('\d\+')

def FuzzyBuffer(arglead: string, _: string, _: number): list<string>
  var bufs = execute('buffers', 'silent!')->split("\n")
  var altbuf = bufs->indexof((_, v) => v =~ '^\s*\d\+\s\+#')
  if altbuf != -1
    [bufs[0], bufs[altbuf]] = [bufs[altbuf], bufs[0]]
  endif
  return arglead == '' ? bufs : bufs->matchfuzzy(arglead)
enddef

# --------------------------
# Preserve history completion and select first item by default
# --------------------------
var selected_menu_item = null_string

autocmd CmdlineLeavePre : ExtractSelectedItem()

def ExtractSelectedItem()
  selected_menu_item = ''
  if wildmenumode()
    var info = cmdcomplete_info()
    if info != {} && !info.matches->empty()
      selected_menu_item = info.selected != -1 ? info.matches[info.selected] : info.matches[0]
      if getcmdline() =~ '^\s*Grep\s'
        setcmdline(info.cmdline_orig)
      endif
    endif
  endif
enddef

# vim: shiftwidth=2 sts=2 expandtab
