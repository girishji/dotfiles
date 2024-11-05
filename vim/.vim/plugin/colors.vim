vim9script

# NOTE: 'background' is not set correctly until window is opened (after VimEnter). So,
# set the background explicitly so that colorscheme can choose appropriate colors.
# Ex:
#   set background=dark
#   colorscheme blue
# Preview here: https://vimcolorschemes.com/vim/colorschemes (ubunto mono font)

augroup ModifyColorscheme | autocmd!
    autocmd ColorScheme darkblue {
        hi Pmenu ctermfg=252 ctermbg=18
        hi PmenuMatch ctermbg=18
        hi PmenuSel ctermbg=252
        hi PmenuMatchSel ctermbg=252
        hi MoreMsg ctermfg=34
    }
augroup END

# If env var is set, use it.
if exists("$VIMBG") && expandcmd($VIMBG) != null_string
    exec $'set background={expandcmd($VIMBG)}'
endif
if exists("$VIMCOLORSCHEME") && expandcmd($VIMCOLORSCHEME) != null_string
    exec $'colorscheme {expandcmd($VIMCOLORSCHEME)}'
endif

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/
