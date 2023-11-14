if !has('vim9script') ||  v:version < 900
    echoe "Needs Vim version 9.0 and above"
    finish
endif

vim9script

# Jump to any character on the screen, like 'easymotion' plugin. mapped to ','.
# Can use 'd,xx' to delete or 'v,xx' to select in visual mode.

g:easyjump_case = get(g:, 'easyjump_case', 'smart') # case/icase/smart
g:easyjump_mapkeys = get(g:, 'easyjump_mapkeys', true)

:highlight default link EasyJump MatchParen

var alpha = 'qwertyuiopasdfghjklzxcvbnm'
var targets = $'{alpha}{alpha->toupper()}0123456789'->split('\zs')

def Jump()
    var positions: list<list<number>> = [] # A list of positions to jump to
    var propname = 'EasyJump'
    var [lstart, lend] = [line('w0'), line('w$')]
    var curpos = getcurpos()
    var ch = getcharstr()
    var ignorecase = (g:easyjump_case ==? 'icase' || (g:easyjump_case ==? 'smart' && ch == ch->tolower())) ? true : false
    ch = ignorecase ? ch->tolower() : ch

    for lnum in range(lstart, lend)
        var line = ignorecase ? getline(lnum)->tolower() : getline(lnum)
        var cnum = line->stridx(ch)
        while cnum != -1
            if ch == ' ' && !positions->empty() && positions[-1] == [lnum, cnum]
                positions[-1][1] = cnum + 1
            elseif [lnum, cnum + 1] != [curpos[1], curpos[2]]
                positions->add([lnum, cnum + 1])
            endif
            cnum = line->stridx(ch, cnum + 1)
        endwhile
    endfor
    if positions->empty()
        return
    endif
    # shuffle positions list keeping at least one target per line
    var reqd = [positions[0]]
    var remaining = []
    for p in range(1, positions->len() - 1)
        if positions[p][0] != positions[p - 1][0]
            reqd->add(positions[p])
        else
            remaining->add(positions[p])
        endif
    endfor
    remaining = remaining->mapnew((_, v) => [v, rand()])->sort((a, b) => a[1] < b[1] ? 0 : 1)->mapnew((_, v) => v[0])
    positions = reqd + remaining

    var ngroups = positions->len() / targets->len() + 1
    var group = 0

    def ShowTargets()
        prop_type_delete(propname)
        prop_type_add(propname, {highlight: 'EasyJump', override: true, priority: 11})
        try
            for idx in range(targets->len())
                var pidx = group * targets->len() + idx
                if pidx < positions->len()
                    var [lnum, cnum] = positions[pidx]
                    prop_add(lnum, cnum + 1, {type: propname, text: targets[idx]})
                else
                    break
                endif
            endfor
        finally
            :redraw
        endtry
    enddef

    def JumpTo(tgt: string)
        var jumpto = targets->index(tgt)
        if jumpto != -1
            cursor(positions[group * targets->len() + jumpto])
            # add to jumplist (:jumps)
            :normal! m'
        endif
    enddef

    try
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
        prop_type_delete(propname)
    endtry
enddef

nnoremap <silent> <Plug>EasyjumpJump; :<c-u>call <SID>Jump()<cr>
xnoremap <silent> <Plug>EasyjumpJump; :<c-u>call <SID>Jump()<cr>
onoremap <silent> <Plug>EasyjumpJump; :<c-u>call <SID>Jump()<cr>

if !exists(":EasyJump")
    command EasyJump Jump()
endif

if g:easyjump_mapkeys
    if !hasmapto('<Plug>EasyjumpJump;', 'n') && mapcheck(',', 'n') ==# ''
        nmap , <Plug>EasyjumpJump;
        omap , <Plug>EasyjumpJump;
        xmap , <Plug>EasyjumpJump;
        vmap <silent> , <cmd>EasyJump<cr>
    endif
endif
