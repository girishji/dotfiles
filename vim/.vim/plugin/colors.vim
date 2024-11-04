vim9script

# NOTE: 'background' is not set correctly until window is opened (after VimEnter). So,
# set the background explicitly so that colorscheme (like 'blue') can choose
# appropriate colors.
# set background=dark
# colorscheme blue
# Preview here: https://vimcolorschemes.com/vim/colorschemes (ubunto mono font)

# If env var is set, use it.
if exists("$VIMBG")
    exec $'set background={expandcmd($VIMBG)}'
endif
if exists("$VIMCOLORSCHEME")
    exec $'colorscheme {expandcmd($VIMCOLORSCHEME)}'
endif

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/
