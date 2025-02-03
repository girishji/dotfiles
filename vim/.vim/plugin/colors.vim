vim9script

# NOTE: 'background' is not set correctly until window is opened (after VimEnter). So,
# set the background explicitly so that colorscheme can choose appropriate colors.
# Ex:
#   set background=dark
#   colorscheme blue
# Preview here: https://vimcolorschemes.com/vim/colorschemes (ubunto mono font)

augroup ModifyColorscheme | autocmd!
    autocmd ColorScheme darkblue {
        hi Pmenu ctermfg=253 ctermbg=20
        hi PmenuMatch ctermbg=18
        hi PmenuSel ctermbg=253
        hi PmenuMatchSel ctermbg=253
        hi MoreMsg ctermfg=34
    }
augroup END

# If env var is set, use it.
if expandcmd($VIM_BG) != null_string
    exec $'set background={expandcmd($VIM_BG)}'
endif

if expandcmd($VIM_COLORSCHEME) != null_string
    exec $'colorscheme {expandcmd($VIM_COLORSCHEME)}'
endif

# Not having any colorscheme is good enough for many terminal profiles
# Adjust colors for source files and leave as is for help/markdown/etc.
if get(g:, 'colors_name', null_string) == null_string
    augroup ColorMonochrome | autocmd!
        autocmd WinEnter,BufEnter,BufReadPost * {
            if expand('%') == '' || expand('%:e') =~ 'py\|cpp\|c\|vim\|java\|make\|sh'
                ColorCorrect()
            else
                syntax reset
            endif
        }
    augroup END
endif

def ColorCorrect()
    var monochrome = false
    if monochrome
        hi Type ctermfg=None cterm=bold
        hi Statement ctermfg=None cterm=bold
        hi String ctermfg=None cterm=bold
        hi Identifier ctermfg=None cterm=bold
        hi Special ctermfg=None
        hi Operator ctermfg=None
        hi Constant ctermfg=None
        hi PreProc ctermfg=None cterm=italic
    else
        # https://ethanschoonover.com/solarized/ (16 colors are same b/w
        #   light/dark, except 4 colors are swapped)
        if &bg == 'light'
            hi Comment ctermfg=14
            hi SignColumn ctermfg=None ctermbg=7
            hi LineNr ctermfg=14 ctermbg=7
            hi StatusLine ctermfg=10 ctermbg=7 cterm=bold
            hi Pmenu ctermfg=none ctermbg=7
            hi PmenuSel ctermfg=7 ctermbg=0
            hi SpecialKey ctermfg=14 |# 'tab', 'nbsp', 'space', etc.
            hi NonText ctermfg=14 |# 'eol', etc.
            hi Search ctermfg=7
        else  # dark
            hi Comment ctermfg=10
            hi SignColumn ctermfg=None ctermbg=0
            hi LineNr ctermfg=11 ctermbg=0
            hi StatusLine ctermfg=14 ctermbg=0 cterm=bold
            hi Pmenu ctermfg=none ctermbg=0
            hi PmenuSel ctermfg=0 ctermbg=4
            hi SpecialKey ctermfg=10 |# 'tab', 'nbsp', 'space', etc.
            hi NonText ctermfg=10 |# 'eol', etc.
            hi Search ctermfg=0
        endif
        hi Constant ctermfg=4
        hi String ctermfg=6
        hi Statement ctermfg=2
        hi Identifier ctermfg=4 cterm=none
        hi PreProc ctermfg=1
        hi Special ctermfg=1
        hi Type ctermfg=3
        hi PmenuMatch ctermfg=3
        hi PmenuMatchSel ctermfg=3
        hi MatchParen ctermfg=1 ctermbg=none cterm=underline

        # from: https://www.youtube.com/watch?v=I8DaJbSbenE
        # if &bg == 'light'
        #     hi Type ctermfg=4 cterm=bold |# 'Type' is set to green which can be too light
        #     hi Statement ctermfg=4 cterm=bold
        #     hi String ctermfg=2 cterm=bold
        #     hi Constant ctermfg=5
        #     hi PreProc ctermfg=5 cterm=bold
        #     hi Identifier ctermfg=5 cterm=bold
        # else  # dark
        # endif
        # hi LineNr ctermfg=8
        # hi Comment ctermfg=8
        # hi link FfTtSubtle Ignore
        # hi link markdownCodeBlock Constant
        # hi link PmenuMatch wildmenu
        # hi MatchParen ctermbg=none cterm=underline
        # hi SpecialKey ctermfg=8 |# 'tab', 'nbsp', 'space', etc.
        # hi NonText ctermfg=8 |# 'eol', etc.
    endif
    var bg = hlget('SignColumn')->get(0, {})->get('ctermbg', null_string)
    if (bg != null_string)
        exec $'hi GitGutterAdd ctermbg={bg}'
        exec $'hi GitGutterChange ctermbg={bg}'
        exec $'hi GitGutterDelete ctermbg={bg}'
    endif
enddef

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/
