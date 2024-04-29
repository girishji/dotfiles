vim9script

export def Surround(c: string)
    if mode() == 'CTRL-V'
        return
    endif
    var [line_start, col_start] = getpos('v')[1 : 2]
    var [line_end, col_end] = getpos('.')[1 : 2]
    if mode() == 'V'
        col_start = 0
        col_end = v:maxcol
    endif
    var reverse = line_start > line_end || (line_start == line_end && col_start > col_end)
    for lnum in range(line_start, line_end, reverse ? -1 : 1)
        var line = lnum->getline()
        var start = lnum == line_start ? col_start - 1 : (reverse ? line->len() : 0)
        var end = lnum == line_end ? col_end - 1 : (reverse ? 0 : line->len())
        var newline = reverse ?
            $'{line->strpart(0, end)}{c}{line->strpart(end, start - end + 1)}{c}{line->strpart(start + 1)}' :
            $'{line->strpart(0, start)}{c}{line->strpart(start, end - start + 1)}{c}{line->strpart(end + 1)}'
        newline->setline(lnum)
    endfor
enddef

# Fix spaces in text:
# * replace non-breaking spaces with spaces
# * replace multiple spaces with a single space (preserving indent)
# * remove spaces between closed braces: ) ) -> ))
# * remove space before closed brace: word ) -> word)
# * remove space after opened brace: ( word -> (word
# * remove space at the end of line
# Usage:
# command! -range FixSpaces call text#fix_spaces(<line1>,<line2>)
export def FixSpaces(line1: number, line2: number)
    var view = winsaveview()
    # replace non-breaking space to space first
    exe printf('silent :%d,%ds/\%%xA0/ /ge', line1, line2)
    # replace multiple spaces to a single space (preserving indent)
    exe printf('silent :%d,%ds/\S\+\zs\(\s\|\%%xa0\)\+/ /ge', line1, line2)
    # remove spaces between closed braces: ) ) -> ))
    exe printf('silent :%d,%ds/)\s\+)\@=/)/ge', line1, line2)
    # remove spaces between opened braces: ( ( -> ((
    exe printf('silent :%d,%ds/(\s\+(\@=/(/ge', line1, line2)
    # remove space before closed brace: word ) -> word)
    exe printf('silent :%d,%ds/\s)/)/ge', line1, line2)
    # remove space after opened brace: ( word -> (word
    exe printf('silent :%d,%ds/(\s/(/ge', line1, line2)
    # remove space at the end of line
    exe printf('silent :%d,%ds/\s*$//ge', line1, line2)
    winrestview(view)
enddef

# 26 simple text objects
# ----------------------
# i_ i. i: i, i; i| i/ i\ i* i+ i- i# i<tab>
# a_ a. a: a, a; a| a/ a\ a* a+ a- a# a<tab>
# Usage:
# for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '<tab>' ]
#     execute 'xnoremap <silent> i' .. char .. ' :<C-u>call text#Obj("' .. char .. '", 1)<CR>'
#     execute 'xnoremap <silent> a' .. char .. ' :<C-u>call text#Obj("' .. char .. '", 0)<CR>'
#     execute 'onoremap <silent> i' .. char .. ' :normal vi' .. char .. '<CR>'
#     execute 'onoremap <silent> a' .. char .. ' :normal va' .. char .. '<CR>'
# endfor
export def Obj(char: string, inner: bool)
    var lnum = line('.')
    var echar = escape(char, '.*')
    if (search('^\|' .. echar, 'cnbW', lnum) > 0 && search(echar, 'W', lnum) > 0)
        || (search(echar, 'nbW', lnum) > 0 && search(echar .. '\|$', 'cW', lnum) > 0)
        if inner
            search('[^' .. char .. ']', 'cbW', lnum)
        endif
        normal! v
        search('^\|' .. echar, 'bW', lnum)
        if inner
            search('[^' .. char .. ']', 'cW', lnum)
        endif
        return
    endif
enddef

# Toggle current word
# nnoremap <silent> <BS> <cmd>call text#Toggle()<CR>
export def Toggle()
    var toggles = {
        true: 'false', false: 'true', True: 'False', False: 'True', TRUE: 'FALSE', FALSE: 'TRUE',
        yes: 'no', no: 'yes', Yes: 'No', No: 'Yes', YES: 'NO', NO: 'YES',
        on: 'off', off: 'on', On: 'Off', Off: 'On', ON: 'OFF', OFF: 'ON',
        open: 'close', close: 'open', Open: 'Close', Close: 'Open',
        dark: 'light', light: 'dark',
        width: 'height', height: 'width',
        first: 'last', last: 'first',
        left: 'right', right: 'left',
        top: 'bottom', bottom: 'top',
        # top: 'right', right: 'bottom', bottom: 'left', left: 'center', center: 'top',
    }
    var word = expand("<cword>")
    if toggles->has_key(word)
        execute 'normal! "_ciw' .. toggles[word]
    endif
enddef
