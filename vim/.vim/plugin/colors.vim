vim9script

def Quiet()
    highlight  Normal                   ctermbg=None
    highlight  helpHyperTextJump        cterm=underline
    highlight  helpHyperTextEntry       cterm=italic
    highlight  helpHeader               cterm=bold
    highlight  helpCommand              ctermfg=248
    highlight  link helpNote            Normal
    highlight  Comment                  ctermfg=244
    highlight  LineNr                   ctermfg=244
    highlight  PreProc                  cterm=bold
    highlight  helpExample              ctermfg=248
    highlight  LspSigActiveParameter    ctermfg=207
    highlight  statusline    ctermbg=none  ctermfg=242  guibg=Grey35  cterm=none
    highlight  statuslinenc  ctermbg=none  ctermfg=242  guibg=Grey35  cterm=none
    highlight  user1         ctermbg=none  ctermfg=250  cterm=none
    highlight  user2         ctermbg=none  ctermfg=250     cterm=none
    highlight  user3         ctermbg=none  ctermfg=250     cterm=none
    highlight  user4         ctermbg=none  ctermfg=3     cterm=none
    highlight FilterMenuMatch ctermfg=209
    highlight PopupBorderHighlight ctermfg=244
    # highlight! link PmenuKind Pmenu
    highlight  PmenuKind       ctermfg=246  ctermbg=236   cterm=none
    highlight! link PmenuKindSel    PmenuSel
    # highlight! link PmenuExtra      Pmenu
    highlight  PmenuExtra       ctermfg=246  ctermbg=236   cterm=none
    highlight! link PmenuExtraSel   PmenuSel
    highlight  Pmenu       ctermfg=none  ctermbg=236   cterm=none
    highlight  PmenuSel    ctermfg=none  ctermbg=25
    highlight  PmenuSbar   ctermfg=none  ctermbg=236
    highlight  PmenuThumb  ctermfg=none  ctermbg=240
    highlight  AS_SearchCompletePrefix  ctermfg=209
    # highlight user2 cterm=bold
    # highlight user4 cterm=bold
    # iceberg iterm theme
    # highlight  Pmenu       ctermfg=232  ctermbg=2    cterm=none
    # highlight  PmenuSel    ctermbg=231
    # highlight  AS_SearchCompletePrefix  ctermfg=124
enddef

def Slate()
    if &background == 'dark'
        highlight  Comment  ctermfg=246
        highlight  Type     ctermfg=71   cterm=bold
        highlight  ModeMsg  ctermfg=235  ctermbg=220  cterm=reverse
    else
        highlight Normal ctermbg=None
        highlight Pmenu ctermbg=193
    endif
enddef

def Sorbet()
    highlight  AS_SearchCompletePrefix  ctermfg=124
enddef

augroup colorschemes | autocmd!
    autocmd ColorScheme quiet Quiet()
    autocmd ColorScheme slate Slate()
    autocmd ColorScheme sorbet Sorbet()
augroup END

:highlight TrailingWhitespace ctermbg=196
:match TrailingWhitespace /\s\+\%#\@<!$/

if &background == 'dark'
    # Preview here: https://vimcolorschemes.com/vim/colorschemes
    silent! colorscheme quiet
else
    silent! colorscheme lunaperche
endif

