if !has('vim9script') ||  v:version < 900
    echoe "Needs Vim version 9.0 and above"
    finish
endif

vim9script

# Jump to any character on the screen, like 'easymotion'.

var letters = 'qwertyuiopasdfghjklzxcvbnm'
letters = letters .. letters->toupper() .. '0123456789'

def Jump()
    var ch = getcharstr()
    var positions = []
    var propname = 'EasyJumpProp'
    var [lstart, lend] = [line('w0'), line('w$')]
    var curpos = getcurpos()
    for lnum in range(lstart, lend)
        var cnum = getline(lnum)->match(ch)
        while cnum != -1
            if [lnum, cnum + 1] != [curpos[1], curpos[2]]
                positions->add([lnum, cnum + 1])
            endif
            cnum = getline(lnum)->match(ch, cnum + 1)
        endwhile
    endfor
    var id: number
    try
        # id = matchaddpos('Search', positions, 11)
        prop_type_add(propname, {highlight: 'MatchParen', override: true, priority: 11})
        var targets = letters->slice(0, positions->len())->split('\zs')
        # randomize
        targets = targets->mapnew((_, v) => [v, rand()])->sort((a, b) => a[1] < b[1] ? 0 : 1)->mapnew((_, v) => v[0])

        echom targets->len()
        echom positions->len()
        for idx in range(targets->len())
            var [lnum, cnum] = positions[idx]
            prop_add(lnum, cnum + 1, {type: propname, text: targets[idx]})
        endfor
        :redraw
        ch = getcharstr()
        var jumpto = targets->index(ch)
        if jumpto != -1
            cursor(positions[jumpto])
        endif

    finally
        # matchdelete(id)
        prop_type_delete(propname)
    endtry
enddef

command EasyJump Jump()
nnoremap , <cmd>EasyJump<cr>
