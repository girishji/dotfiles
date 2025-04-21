vim9script
# MacVim

set guifont=Ubuntu\ Mono:h16
set lines=34 columns=110
colorscheme unokai

# --------------------------
# Highlight On Yank
# --------------------------
autocmd TextYankPost * HighlightOnYank()
export def HighlightOnYank(hlgroup = 'IncSearch', duration = 300, in_visual = true)
    if v:event.operator ==? 'y'
        if !in_visual && visualmode() != null_string
            visualmode(1)
            return
        endif
        var [beg, end] = [getpos("'["), getpos("']")]
        var type = v:event.regtype ?? 'v'
        var pos = getregionpos(beg, end, {type: type, exclusive: false})
        var m = matchaddpos(hlgroup, pos->mapnew((_, v) => {
            var col_beg = v[0][2] + v[0][3]
            var col_end = v[1][2] + v[1][3] + 1
            return [v[0][1], col_beg, col_end - col_beg]
        }))
        var winid = win_getid()
        timer_start(duration, (_) => {
            # keymap like `:vmap // y/<C-R>"<CR>` (search for visually selected text) throws E803
            try
                m->matchdelete(winid)
            catch
            endtry
        })
    endif
enddef

# --------------------------
# Cmdline auto-completion
# --------------------------
# set wim=noselect:lastused,full wop=pum wcm=<C-@> wmnu
# autocmd CmdlineChanged : CmdComplete()
# def CmdComplete()
#     var [cmdline, curpos] = [getcmdline(), getcmdpos()]
#     if getchar(1, {number: true}) == 0  # Typehead is empty (no more pasted input)
#             && !pumvisible() && curpos == cmdline->len() + 1
#             && cmdline =~ '\%(\w\|[*/:.-]\)$' && cmdline !~ '^\d\+$'  # Reduce noise
#         feedkeys("\<C-@>", "ti")
#         SkipCmdlineChanged()  # Suppress redundant completion attempts
#         # Remove <C-@> that get inserted when no items are available
#         timer_start(0, (_) => getcmdline()->substitute('\%x00', '', 'g')->setcmdline())
#     endif
# enddef
# cnoremap <expr> <up> SkipCmdlineChanged("\<up>")
# cnoremap <expr> <down> SkipCmdlineChanged("\<down>")
# autocmd CmdlineEnter : set bo+=error
# autocmd CmdlineLeave : set bo-=error
# def SkipCmdlineChanged(key = ''): string
#     set ei+=CmdlineChanged
#     timer_start(0, (_) => execute('set ei-=CmdlineChanged'))
#     return key != '' ? ((pumvisible() ? "\<c-e>" : '') .. key) : ''
# enddef

# --------------------------
# Fuzzy find file
# --------------------------
# set findfunc=FuzzyFind
# def FuzzyFind(cmdarg: string, _: bool): list<string>
#     if allfiles == null_list
#         allfiles = systemlist($'find {get(g:, "fzfind_root", ".")} \! \( -path "*/.git" -prune -o -name "*.swp" \) -type f -follow')
#     endif
#     return cmdarg == '' ? allfiles : allfiles->matchfuzzy(cmdarg)
# enddef
# var allfiles: list<string>
# autocmd CmdlineEnter : allfiles = null_list
# nnoremap <leader><space> :<c-r>=execute('let fzfind_root="."')\|''<cr>Find<space><c-@>
# nnoremap <leader>fv :<c-r>=execute('let fzfind_root="$HOME/.vim"')\|''<cr>Find<space><c-@>
# nnoremap <leader>fV :<c-r>=execute('let fzfind_root="$VIMRUNTIME"')\|''<cr>Find<space><c-@>

# --------------------------
# Live grep
# --------------------------
# command! -nargs=+ -complete=customlist,GrepComplete Grep VisitFile(<q-args>)
# def GrepComplete(arglead: string, cmdline: string, cursorpos: number): list<any>
#     return arglead->len() > 1 ? systemlist($'ggrep -REIHns "{arglead}"' ..
#        ' --exclude-dir=.git --exclude=".*" --exclude="tags" --exclude="*.swp"') : []
# enddef
# def VisitFile(match: string)
#     if (match != null_string)
#         var qfitem = getqflist({lines: [match]}).items[0]
#         if qfitem->has_key('bufnr') && qfitem.lnum > 0
#             var pos = qfitem.vcol > 0 ? 'setcharpos' : 'setpos'
#             exec $':b +call\ {pos}(".",\ [0,\ {qfitem.lnum},\ {qfitem.col},\ 0]) {qfitem.bufnr}'
#             setbufvar(qfitem.bufnr, '&buflisted', 1)
#         endif
#     endif
# enddef
# nnoremap <leader>g :Grep<space>
# nnoremap <leader>G :Grep <c-r>=expand("<cword>")<cr>

# --------------------------
# Fuzzy find buffer
# --------------------------
# command! -nargs=* -complete=customlist,FuzzyBuffer Buffer execute('b ' .. expand('<q-args>')->matchstr('\d\+'))
# def FuzzyBuffer(arglead: string, _: string, _: number): list<string>
#     var bufs = execute('buffers', 'silent!')->split("\n")
#     var altbuf = bufs->indexof((_, v) => v =~ '^\s*\d\+\s\+#')
#     if altbuf != -1
#         [bufs[0], bufs[altbuf]] = [bufs[altbuf], bufs[0]]
#     endif
#     return arglead == '' ? bufs : bufs->matchfuzzy(arglead)
# enddef
# nnoremap <leader><bs> :Buffer <c-@>

# ---------------------------
# Insert Mode Auto-completion
# ---------------------------
# hi ComplMatchIns ctermfg=1
set cot=menuone,popup,noselect inf cpt-=t,i
echom &cot
autocmd TextChangedI * InsComplete()
def InsComplete()
    if getcharstr(1) == '' && getline('.')->strpart(0, col('.') - 1) =~ '\k$'
        SkipTextChangedI() # Suppress event caused by <c-n> if completion candidates not found
        feedkeys("\<c-n>", "n")
    endif
enddef
inoremap <silent> <c-e> <c-r>=<SID>SkipTextChangedI()<cr><c-e>
def SkipTextChangedI(): string
    set eventignore+=TextChangedI  # Suppress next event caused by <c-e> (or <c-n> when no matches found)
    timer_start(1, (_) => {
        set eventignore-=TextChangedI
    })
    return ''
enddef
inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

#------------------------------------------------------------
# vim: ts=8 sts=4 sw=4 et fdm=marker
