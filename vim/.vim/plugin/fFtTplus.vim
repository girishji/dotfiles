if !has('vim9script') ||  v:version < 900
    finish
endif

vim9script

var id: number

def HighligtClear()
    if id > 0
        matchdelete(id, 10 + 1)
        :redraw
        id = 0
    endif
enddef

augroup fFtTplusHighlight | autocmd!
    autocmd CursorMoved,ModeChanged,TextChanged,WinEnter,WinLeave,CmdWinLeave * HighligtClear()
augroup END

def HighligtChars(s: string): string
    var [_, lnum, col, _] = getpos('.')
    var freq = {}
    var line = getline('.')
    for ch in line->split('\zs')
        freq[ch] = freq->get(ch, 0) + 1
    endfor
    freq->filter((_, v) => v > 1)

    var dir = {
        f: {start: col - 1, reverse: false},
        t: {start: col, reverse: false},
        F: {start: col - 1, reverse: true},
        T: {start: col - 2, reverse: true},
    }
    var locations = {}
    for ch in freq->keys()
        var loc = dir[s].reverse ? line->strridx(ch, dir[s].start) : line->stridx(ch, dir[s].start)
        while loc != -1
            locations[ch] = locations->get(ch, [])->add(loc + 1)
            loc = dir[s].reverse ? line->strridx(ch, loc - 1) : line->stridx(ch, loc + 1)
        endwhile
    endfor

    var loclist = []
    for val in locations->values()
        loclist += val->slice(1)
    endfor
    loclist->map((_, v) => [lnum, v])
    if !loclist->empty()
        id = matchaddpos('Comment', loclist)
    endif
    :redraw
    return ''
enddef

noremap <silent><expr> <Plug>(fFtTplus-f) HighligtChars('f')
noremap <silent><expr> <Plug>(fFtTplus-F) HighligtChars('F')
noremap <silent><expr> <Plug>(fFtTplus-t) HighligtChars('t')
noremap <silent><expr> <Plug>(fFtTplus-T) HighligtChars('T')

nnoremap f <Plug>(fFtTplus-f)f
xnoremap f <Plug>(fFtTplus-f)f
onoremap f <Plug>(fFtTplus-f)f
nnoremap F <Plug>(fFtTplus-F)F
xnoremap F <Plug>(fFtTplus-F)F
onoremap F <Plug>(fFtTplus-F)F
nnoremap t <Plug>(fFtTplus-t)t
xnoremap t <Plug>(fFtTplus-t)t
onoremap t <Plug>(fFtTplus-t)t
nnoremap T <Plug>(fFtTplus-T)T
xnoremap T <Plug>(fFtTplus-T)T
onoremap T <Plug>(fFtTplus-T)T
