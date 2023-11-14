if !has('vim9script') ||  v:version < 900
    echoe "Needs Vim version 9.0 and above"
    finish
endif

vim9script

# Jump to any character on the screen, like 'easymotion' plugin.

var alpha = 'qwertyuiopasdfghjklzxcvbnm'
var targets = $'{alpha}{alpha->toupper()}0123456789'->split('\zs')

def Jump()
    var ch = getcharstr()
    var positions: list<list<number>> = [] # A list of positions to jump to
    var propname = 'EasyJump'
    var [lstart, lend] = [line('w0'), line('w$')]
    var curpos = getcurpos()
    for lnum in range(lstart, lend)
        var cnum = getline(lnum)->match(ch)
        while cnum != -1
            if ch == ' ' && !positions->empty() && positions[-1] == [lnum, cnum]
                positions[-1][1] = cnum + 1
            elseif [lnum, cnum + 1] != [curpos[1], curpos[2]]
                positions->add([lnum, cnum + 1])
            endif
            cnum = getline(lnum)->match(ch, cnum + 1)
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
        prop_type_add(propname, {highlight: 'MatchParen', override: true, priority: 11})
        try
            for idx in range(targets->len())
                var pidx = (group * targets->len()) + idx
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

    def JumpTo(t: string)
        var jumpto = targets->index(t)
        if jumpto != -1
            cursor(positions[jumpto])
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

command EasyJump Jump()
nnoremap , <cmd>EasyJump<cr>
