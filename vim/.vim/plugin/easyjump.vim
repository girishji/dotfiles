if !has('vim9script') ||  v:version < 900
    echoe "Needs Vim version 9.0 and above"
    finish
endif

vim9script

# Trigger. Target. Choose.
# Jump to any character on screen using 3 characters.
# Vim idioms supported:
#   - Jump list updated so that you can jump back using <ctrl-o>
#   - Mapped to ','. Can use 'd,xx' to delete, 'c,xx', 'v,xx', etc.

g:easyjump_case = get(g:, 'easyjump_case', 'smart') # case/icase/smart
g:easyjump_mapkeys = get(g:, 'easyjump_mapkeys', true)

:highlight default link EasyJump MatchParen

var alpha = 'asdfgwercvhjkluiopynmbtqxz'
var letters = $'{alpha}{alpha->toupper()}0123456789'->split('\zs')

def Jump()
    var targets: list<list<number>> = [] # A list of positions to jump to
    var propname = 'EasyJump'
    var [lstart, lend] = [line('w0'), line('w$')]
    var curpos = getcurpos()
    var ch = getcharstr()
    var ignorecase = (g:easyjump_case ==? 'icase' || (g:easyjump_case ==? 'smart' && ch == ch->tolower())) ? true : false
    ch = ignorecase ? ch->tolower() : ch

    # Gather targets to jump to, starting from cursor and searching outwards
    var curline = curpos[1]
    var linenrs = [curline]
    for dist in range(1, (lend - lstart))
        if curline + dist <= lend
            linenrs->add(curline + dist)
        endif
        if curline - dist >= lstart
            linenrs->add(curline - dist)
        endif
    endfor
    for lnum in linenrs
        var line = ignorecase ? getline(lnum)->tolower() : getline(lnum)
        var cnum = line->stridx(ch)
        while cnum != -1 && ([lnum, cnum + 1] != [curpos[1], curpos[2]])
            if ch == ' ' && !targets->empty() && targets[-1] == [lnum, cnum]
                targets[-1][1] = cnum + 1
            else
                targets->add([lnum, cnum + 1])
            endif
            cnum = line->stridx(ch, cnum + 1)
        endwhile
    endfor
    if targets->empty()
        return
    endif

    if letters->copy()->sort()->uniq()->len() != letters->len()
        echoe 'EasyJump: Letters list has duplicates'
    endif
    # If target count > letters count, split into groups
    var ngroups = targets->len() / letters->len() + 1
    var group = 0

    # Prioritize: Keep more targets near cursor, at least one per line
    def Prioritize()
        var reqd = []
        var remaining = []
        var expected = targets->len()
        def FilterTargets(tlinenr: number, tmax: number)
            if tlinenr < lstart || tlinenr > lend
                return
            endif
            var curtargets = targets->copy()->filter((_, v) => v[0] == tlinenr)
            targets->filter((_, v) => v[0] != tlinenr)
            reqd->extend(curtargets->slice(0, tmax))
            remaining->extend(curtargets->slice(tmax))
        enddef

        FilterTargets(curline, 10) # 10 targets max
        if targets->len() > (lend - lstart)
            var excess = targets->len() - (lend - lstart)
            FilterTargets(curline + 1, excess / 3)
            FilterTargets(curline - 1, excess / 3)
        endif
        # one per line
        for p in range(targets->len())
            if targets[p][0] != targets[p - 1][0]
                reqd->add(targets[p])
            else
                remaining->add(targets[p])
            endif
        endfor
        # shuffle the remaining targets
        remaining = remaining->mapnew((_, v) => [v, rand()])->sort((a, b) => a[1] < b[1] ? 0 : 1)->mapnew((_, v) => v[0])
        targets = reqd + remaining
        # error check
        if expected != targets->len()
            echoe 'EasyJump: Target list filter error'
        endif
        if targets->copy()->sort()->uniq()->len() != targets->len()
            echoe 'EasyJump: Targets list has duplicates'
        endif
    enddef

    def ShowTargets()
        prop_type_delete(propname)
        prop_type_add(propname, {highlight: 'EasyJump', override: true, priority: 11})
        try
            for idx in range(letters->len())
                var tidx = group * letters->len() + idx
                if tidx < targets->len()
                    var [lnum, cnum] = targets[tidx]
                    prop_add(lnum, cnum + 1, {type: propname, text: letters[idx]})
                else
                    break
                endif
            endfor
        finally
            :redraw
        endtry
    enddef

    def JumpTo(tgt: string)
        var jumpto = letters->index(tgt)
        if jumpto != -1
            cursor(targets[group * letters->len() + jumpto])
            # add to jumplist (:jumps)
            :normal! m'
        endif
    enddef

    try
        Prioritize()
        Verify()
        ShowTargets()
        if ngroups > 1
            while true
                ch = getcharstr()
                if ch == ';' || ch == ',' || ch == "\<tab>"
                    group = (group + 1) % ngroups
                    ShowTargets()
                else
                    JumpTo(ch)
                    break
                endif
            endwhile
        else
            ch = getcharstr()
            JumpTo(ch)
        endif
    finally
        if !prop_type_get(propname)->empty()
            while prop_remove({type: propname}, lstart, lend) > 0
            endwhile
        endif
        # prop_type_delete(propname) # XXX Vim bug: 'J' after jump causes corruption
    endtry
enddef

def VJump()
    Jump()
    :normal! m'
    :normal! gv``
enddef

nnoremap <silent> <Plug>EasyjumpJump; :<c-u>call <SID>Jump()<cr>
onoremap <silent> <Plug>EasyjumpJump; :<c-u>call <SID>Jump()<cr>
vnoremap <silent> <Plug>EasyjumpVJump; :<c-u>call <SID>VJump()<cr>

if g:easyjump_mapkeys
    if !hasmapto('<Plug>EasyjumpJump;', 'n') && mapcheck(',', 'n') ==# ''
        nmap , <Plug>EasyjumpJump;
        omap , <Plug>EasyjumpJump;
        vmap , <Plug>EasyjumpVJump;
    endif
endif
