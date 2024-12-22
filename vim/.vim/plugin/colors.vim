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
    autocmd ColorScheme defaultplus {
        hi def link gCppSpecialChar Operator
        hi def link gCppOperator Operator
    }
augroup END

# If env var is set, use it.
if expandcmd($VIM_BG) != null_string
    exec $'set background={expandcmd($VIM_BG)}'
endif

if expandcmd($VIM_COLORSCHEME) != null_string
    exec $'colorscheme {expandcmd($VIM_COLORSCHEME)}'
endif

# Not having any colorscheme is good enough for some terminal profiles (like
# Iceberg).
if get(g:, 'colors_name', null_string) == null_string
    hi LineNr ctermfg=8
    hi Comment ctermfg=8
    hi link FfTtSubtle Ignore
    hi link markdownCodeBlock Constant
    hi link PmenuMatch PmenuSel
    if &bg == 'light'
        hi Type ctermfg=None |# Type is set to green which can be too light
    endif
endif

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/
