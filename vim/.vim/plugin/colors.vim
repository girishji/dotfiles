vim9script

# Macvim
# if has('gui_running')
#     # See :h term_setansicolors() (press 'K')
#     g:terminal_ansi_colors = ['#282923', '#c61e5c', '#81af24', '#fd971f', '#51aebe', '#ae81ff', '#80beb5', '#bababa', '#74705d', '#f92672', '#a6e22e', '#e6db74', '#66d9ef', '#fd5ff0', '#a1efe4', '#f8f8f2']
# endif

# NOTE: 'background' is not set correctly until window is opened (after VimEnter). So,
# set the background explicitly so that colorscheme can choose appropriate colors.

# If env var is set, use it.
if expandcmd($VIM_BG) != null_string
    exec $'set background={expandcmd($VIM_BG)}'
endif

# color 146 -> slightly blue but gray
# color 249 -> gray replacement for 146
# autocmd ColorScheme quiet {
    # hi Comment ctermfg=246 cterm=none
# }
if expandcmd($VIM_COLORSCHEME) != null_string
    exec $'colorscheme {expandcmd($VIM_COLORSCHEME)}'
endif

# colorscheme is not needed. Adjust terminal colors.
# Modify colors for source files and leave defaults for help/markdown files.
if get(g:, 'colors_name', null_string) == null_string
    augroup ColorMonochrome | autocmd!
        autocmd TermResponseAll background call SaneColors() | redraw
        # FileType event is not called every time buffer is switched.
        # BufReadPost will not have &filetype. So defer until filetype
        # is detected.
        autocmd WinEnter,BufEnter,BufReadPost * call timer_start(10, (_) => ApplyColors())
    augroup END
endif

def ApplyColors()
    var monochrome = expandcmd($VIM_CS) == 'mono'
        || expandcmd($VIM_CS) == 'mc'
        || expandcmd($VIM_CS) == 'borland'
    if &filetype !~ 'help\|markdown' && monochrome
        # XXX: Do not use 15. When --clean both error and errormsg have
        # ctermfg=15. Leave them unchanged, otherwise errors are not visible.
        # XXX: Changing color of 'bold' fonts through terminal messess up
        # color of statusline.
        hi Type ctermfg=12 cterm=bold
        hi! link Statement Type
        hi! link Identifier Type
        hi Operator ctermfg=None
        hi Comment ctermfg=14 cterm=italic
        hi String ctermfg=13 cterm=none
        hi Special ctermfg=13
        hi Constant ctermfg=13 cterm=none
        hi PreProc ctermfg=13 cterm=bold
    else
        syntax reset
        hi link StatusLineNC StatusLine
        hi Constant ctermfg=4
        hi String ctermfg=6
        hi Statement ctermfg=2
        hi Identifier ctermfg=4 cterm=none
        hi PreProc ctermfg=1
        hi Special ctermfg=1
        hi Type ctermfg=3
    endif
    SaneColors()
enddef

def SaneColors()
    # XXX: Do not use 15. When --clean both error and errormsg have
    # ctermfg=15. Leave them unchanged, otherwise errors are not visible.
    if &bg == 'light'
        hi SignColumn ctermfg=None ctermbg=7
        hi LineNr ctermfg=11 ctermbg=7
        hi TabLine ctermfg=none ctermbg=7 cterm=none
        hi TabLineFill cterm=none ctermbg=none ctermfg=none
        hi TabLineSel ctermbg=none ctermfg=none cterm=bold,reverse
        hi Pmenu ctermfg=2 ctermbg=7
        hi PmenuMatch ctermfg=5 ctermbg=7
        hi PmenuSel ctermfg=7 ctermbg=8
        hi PmenuMatchSel ctermfg=7 ctermbg=8 cterm=underline
        hi PmenuSbar ctermbg=7
        hi NonText ctermfg=7 |# 'eol', etc.
        hi Search ctermfg=7 ctermbg=3
        hi DiffText ctermfg=15
        hi StatusLine ctermfg=none ctermbg=none cterm=bold,reverse
        hi StatusLineNC ctermfg=none ctermbg=7 cterm=none
        hi StatusLineTerm ctermfg=none ctermbg=7 cterm=bold
        hi link StatusLineTermNC StatusLineNC
        hi Cursorline ctermbg=7 cterm=none
        hi! link CursorlineNr Cursorline
        hi Wildmenu ctermfg=0 ctermbg=7
        # XXX: 'cursorline' makes line unreadable in lldb
        # set cursorline
    else  # dark
        hi SignColumn ctermfg=None ctermbg=0
        hi LineNr ctermfg=11 ctermbg=0
        hi TabLine ctermfg=8 ctermbg=11 cterm=none
        hi TabLineFill cterm=none ctermbg=0 ctermfg=none
        hi TabLineSel ctermbg=none ctermfg=none cterm=bold,reverse
        hi Pmenu ctermfg=2 ctermbg=0
        hi PmenuMatch ctermfg=3 ctermbg=none
        hi PmenuSel ctermfg=8 ctermbg=7
        hi PmenuMatchSel ctermfg=8 ctermbg=7 cterm=underline
        hi PmenuSbar ctermbg=0
        hi PmenuThumb ctermbg=7
        hi NonText ctermfg=0 |# 'eol', etc.
        hi Search ctermfg=0 ctermbg=3
        hi StatusLine ctermfg=none ctermbg=none cterm=bold,reverse
        hi StatusLineNC ctermfg=none ctermbg=0 cterm=none
        hi StatusLineTerm ctermfg=none ctermbg=0 cterm=bold
        hi link StatusLineTermNC StatusLineNC
        hi ColorColumn ctermbg=9
        hi DiffChange ctermbg=9
        hi DiffAdd ctermfg=8
        hi DiffDelete ctermfg=8
        hi Folded ctermbg=0
        hi FoldColumn ctermbg=0
        if expandcmd($VIM_CS) == 'mc'
            MCColors()
        endif
        if expandcmd($VIM_CS) == 'borland'
            BorlandColors()
        endif
    endif
    hi MatchParen ctermfg=1 ctermbg=none cterm=underline
    # hi Todo ctermfg=0 ctermbg=1
    hi Todo ctermfg=none ctermbg=none cterm=reverse,bold
    hi SpecialKey ctermfg=10 |# 'tab', 'nbsp', 'space', ctrl chars (^a, ^b, etc.)
    hi! link EndOfBuffer SpecialKey |# '~' at the beginning of empty lines
enddef

def MCColors()
    hi StatusLine     ctermfg=8 ctermbg=7 cterm=bold
    hi! link StatusLineNC StatusLine
    hi! link StatusLineTerm StatusLine
    hi Pmenu          ctermfg=8 ctermbg=7
    hi PmenuSel       ctermfg=15 ctermbg=8
    hi PmenuMatch     ctermfg=3 ctermbg=6
    hi PmenuMatchSel  cterm=underline ctermfg=3 ctermbg=8
    hi PmenuSbar      ctermbg=14
    hi PmenuThumb     ctermbg=8
    hi PmenuExtra     ctermfg=14 ctermbg=7
    hi PmenuExtraSel  ctermfg=15 ctermbg=8
    hi Added          ctermfg=4
enddef

def BorlandColors()
    hi StatusLine     ctermfg=8 ctermbg=6 cterm=bold
    hi Pmenu          ctermfg=8 ctermbg=2 cterm=bold
    hi PmenuMatch     ctermfg=3 ctermbg=2
    hi PmenuExtra     ctermfg=7 ctermbg=2 cterm=bold
    hi PmenuExtraSel  ctermfg=7 ctermbg=8
    hi PmenuMatchSel  ctermfg=3 ctermbg=8
    # hi StatusLine     ctermfg=8 ctermbg=2 cterm=bold
    # hi Pmenu          ctermfg=8 ctermbg=6 cterm=bold
    # hi PmenuMatch     ctermfg=1 ctermbg=6
    # hi PmenuExtra     ctermfg=7 ctermbg=6 cterm=bold
    # hi PmenuExtraSel  ctermfg=15 ctermbg=7
    # hi PmenuMatchSel  ctermfg=4 ctermbg=8
    hi PmenuSel       ctermfg=15 ctermbg=8
    hi PmenuSbar      ctermbg=7
    hi PmenuThumb     ctermbg=8
    hi Added          ctermfg=4
    hi! link StatusLineNC StatusLine
    hi! link StatusLineTerm StatusLine
enddef

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/

# vim: ts=4 shiftwidth=4 sts=4 expandtab
