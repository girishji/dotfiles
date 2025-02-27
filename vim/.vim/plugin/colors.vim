vim9script

# NOTE: 'background' is not set correctly until window is opened (after VimEnter). So,
# set the background explicitly so that colorscheme can choose appropriate colors.

# If env var is set, use it.
if expandcmd($VIM_BG) != null_string
    exec $'set background={expandcmd($VIM_BG)}'
endif

if expandcmd($VIM_COLORSCHEME) != null_string
    exec $'colorscheme {expandcmd($VIM_COLORSCHEME)}'
endif

# colorscheme is not needed. Adjust terminal colors.
# Modify colors for source files and leave defaults for help/markdown files.
if get(g:, 'colors_name', null_string) == null_string
    augroup ColorMonochrome | autocmd!
        # FileType event is not called every time buffer is switched.
        # BufReadPost will not have &filetype. So defer until filetype
        # is detected.
        autocmd WinEnter,BufEnter,BufReadPost * call timer_start(10, (_) => ApplyColors())
        autocmd OptionSet background ApplyColors()
    augroup END
endif

def SaneColors()
    if &bg == 'light'
        hi SignColumn ctermfg=None ctermbg=7
        hi LineNr ctermfg=12 ctermbg=7
        hi Pmenu ctermfg=none ctermbg=7
        hi PmenuMatch ctermfg=5 ctermbg=7
        hi PmenuSel ctermfg=7 ctermbg=0
        hi PmenuMatchSel ctermfg=7 ctermbg=0 cterm=underline
        hi NonText ctermfg=7 |# 'eol', etc.
        hi Search ctermfg=7 ctermbg=12
        hi DiffText ctermfg=15
        hi StatusLine ctermfg=none ctermbg=7 cterm=bold
        hi StatusLineNC ctermfg=12 ctermbg=none cterm=italic
        hi StatusLineTerm ctermfg=3 ctermbg=7 cterm=none
        hi StatusLineTermNC ctermfg=14 ctermbg=0 cterm=italic
    else  # dark
        hi SignColumn ctermfg=None ctermbg=0
        hi LineNr ctermfg=12 ctermbg=0
        hi Pmenu ctermfg=none ctermbg=0
        hi PmenuMatch ctermfg=3
        hi PmenuSel ctermfg=8 ctermbg=7
        hi PmenuMatchSel ctermfg=8 ctermbg=7 cterm=underline
        hi PmenuSbar ctermbg=0
        hi PmenuThumb ctermbg=7
        hi NonText ctermfg=0 |# 'eol', etc.
        hi Search ctermfg=8 ctermbg=12
        hi StatusLine ctermfg=none ctermbg=0 cterm=bold
        hi StatusLineNC ctermfg=12 ctermbg=none cterm=italic
        hi StatusLineTerm ctermfg=3 ctermbg=0 cterm=none
        hi StatusLineTermNC ctermfg=14 ctermbg=none cterm=italic
    endif
    hi MatchParen ctermfg=1 ctermbg=none cterm=underline
    hi Todo ctermfg=7 ctermbg=1
    hi SpecialKey ctermfg=2 |# 
    hi SpecialKey ctermfg=10 |# 'tab', 'nbsp', 'space', ctrl chars (^a, ^b, etc.)

    var bg = hlget('SignColumn')->get(0, {})->get('ctermbg', null_string)
    if (bg != null_string)
        exec $'hi GitGutterAdd ctermbg={bg}'
        exec $'hi GitGutterChange ctermbg={bg}'
        exec $'hi GitGutterDelete ctermbg={bg}'
    endif
enddef

def ColorCorrect()
    if expandcmd($VIM_MONOCHROME) != null_string
        hi Type ctermfg=None cterm=italic
        hi Statement ctermfg=None cterm=italic
        hi String ctermfg=1 cterm=none
        hi Identifier ctermfg=None cterm=italic
        hi Special ctermfg=1
        hi Operator ctermfg=None
        hi Constant ctermfg=1 cterm=none
        hi PreProc ctermfg=1 cterm=none
    else
        hi Comment ctermfg=11
        hi link StatusLineNC StatusLine
        hi Constant ctermfg=4
        hi String ctermfg=6
        hi Statement ctermfg=2
        hi Identifier ctermfg=4 cterm=none
        hi PreProc ctermfg=1
        hi Special ctermfg=1
        hi Type ctermfg=3
    endif
enddef

def ApplyColors()
    if &filetype !~ 'help\|markdown'
        ColorCorrect()
    else
        syntax reset
    endif
    SaneColors()
enddef

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/
