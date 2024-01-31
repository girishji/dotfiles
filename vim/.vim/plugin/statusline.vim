vim9script

def Gitstr(): string
    var [a, m, r] = exists('*g:GitGutterGetHunkSummary') ? g:GitGutterGetHunkSummary() : [0, 0, 0]
    return (a + m + r) > 0 ? $' (git:{a + m + r})' : ''
enddef

def Diagstr(): string
    var diagstr = ''
    if exists('lsp#lsp#ErrorCount')
        var diag = lsp#lsp#ErrorCount()
        var Severity = (s: string) => {
            return diag[s] != 0 ? $' {s->strpart(0, 1)}:{diag[s]}' : ''
        }
        diagstr = $'{Severity("Error")}{Severity("Warn")}{Severity("Hint")}{Severity("Info")}'
    endif
    return diagstr
enddef

def MyStatuslineSetup()
    if &background == 'dark'
        # set fillchars+=stl:―,stlnc:—
        set fillchars+=stl:─,stlnc:─
        if &termguicolors
            highlight link user1 statusline
            highlight link user2 statusline
            highlight link user4 statusline
        endif
    else
        highlight link user1 statusline
        highlight link user2 statusline
        highlight link user4 statusline
    endif
    highlight! link StatusLineTerm statusline
    highlight! link StatusLineTermNC statuslinenc
    highlight link user3 statusline
    if exists("*g:BuflineSetup")
        g:BuflineSetup({ highlight: true, showbufnr: true })
    endif
enddef

def BuflineStr(width: number): string
    return exists('*g:BuflineGetstr') ? g:BuflineGetstr(width) : ''
enddef

var elapsedTime = 0
def GetElapsed(): string
    var mins = elapsedTime % 60
    var hrs = elapsedTime / 60
    return (hrs < 10 ? $'0{hrs}' : string(hrs)) .. ':' .. (mins < 10 ? $'0{mins}' : string(mins))
enddef

def UpdateElapsed(timer: number)
    if exists('#User#ElapsedTimeUpdated')
        :doau <nomodeline> User ElapsedTimeUpdated
    endif
    elapsedTime += 1
    timer_start(60 * 1000, function(UpdateElapsed))
enddef
timer_start(60 * 1000, function(UpdateElapsed))

def! g:MyActiveStatusline(): string
    var gitstr = Gitstr()
    var diagstr = Diagstr()
    var shortpath = expand('%:h')
    var shortpathmax = 20
    if shortpath->len() > shortpathmax
        shortpath = shortpath->split('/')->map((_, v) => v->slice(0, 2))->join('/')->slice(0, shortpathmax)
    endif
    if !shortpath->empty()
        shortpath = ' ' .. shortpath .. '/'
    endif
    var elapsed = GetElapsed()
    var width = winwidth(0) - 30 - gitstr->len() - diagstr->len() - shortpath->len() - elapsed->len()
    var buflinestr = BuflineStr(width)
    # return $'%4*{diagstr}%* {buflinestr} %= %y %4*{elapsed}%*%4*{gitstr}%*%2*{shortpath}%* ≡ %P (%l:%c) %*'
    return $'%4*{diagstr}%* {buflinestr} %= %y %4*{elapsed}%*%2*{shortpath}%* ≡ %P (%l:%c) %*'
enddef

def! g:MyInactiveStatusline(): string
    return ' %F '
enddef

augroup MyStatusLine | autocmd!
    autocmd VimEnter,ColorScheme * MyStatuslineSetup()
    autocmd WinEnter,BufEnter,BufAdd * setl statusline=%{%g:MyActiveStatusline()%}
    autocmd User LspDiagsUpdated,BufLineUpdated,ElapsedTimeUpdated setl statusline=%{%g:MyActiveStatusline()%}
    autocmd WinLeave,BufLeave * setl statusline=%{%g:MyInactiveStatusline()%}
augroup END
