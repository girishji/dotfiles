vim9script

def Quiet()
    if &background == 'dark'
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
        highlight FilterMenuMatch ctermfg=209 cterm=none
        highlight PopupBorderHighlight ctermfg=244
        highlight  PmenuKind       ctermfg=246  ctermbg=236   cterm=none
        highlight! link PmenuKindSel    PmenuSel
        highlight  PmenuExtra       ctermfg=246  ctermbg=236   cterm=none
        highlight! link PmenuExtraSel   PmenuSel
        highlight  Pmenu       ctermfg=none  ctermbg=236   cterm=none
        highlight  PmenuSel    ctermfg=none  ctermbg=25
        highlight  PmenuSbar   ctermfg=none  ctermbg=236
        highlight  PmenuThumb  ctermfg=none  ctermbg=240
    else
        highlight statusline cterm=none
        highlight Comment  cterm=none ctermfg=242
        highlight Pmenu ctermbg=250
        highlight PmenuThumb ctermfg=none ctermbg=244
        highlight  PmenuKind       ctermfg=242  ctermbg=250   cterm=none
        highlight! link PmenuKindSel    PmenuSel
        highlight  PmenuExtra       ctermfg=242  ctermbg=250   cterm=none
        highlight! link PmenuExtraSel   PmenuSel
        # SpecialKey is used for 'listchars'
        highlight SpecialKey ctermfg=248
        highlight helpHyperTextJump cterm=underline
        highlight helpHyperTextEntry cterm=underline
        g:popupthumbhighlight  = 'statuslinenc'
    endif
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

# Preview here: https://vimcolorschemes.com/vim/colorschemes (ubunto mono font)
if &background == 'dark'
    silent! colorscheme quiet
else
    silent! colorscheme quiet
    # silent! colorscheme lunaperche
endif

