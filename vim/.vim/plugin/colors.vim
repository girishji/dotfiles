vim9script

def Quiet()
    if &background == 'dark'
        highlight Normal ctermbg=None ctermfg=None
        # highlight  Comment                  ctermfg=244
        # highlight  LineNr                   ctermfg=244
        highlight  helpExample              ctermfg=248
        highlight  LspSigActiveParameter    ctermfg=207
        # highlight  statusline    ctermbg=none  ctermfg=242  guibg=Grey35  cterm=none
        # highlight  statuslinenc  ctermbg=none  ctermfg=242  guibg=Grey35  cterm=none
        # highlight  user1         ctermbg=none  ctermfg=250  cterm=none
        # highlight  user2         ctermbg=none  ctermfg=250     cterm=none
        # highlight  user3         ctermbg=none  ctermfg=250     cterm=none
        # highlight  user4         ctermbg=none  ctermfg=3     cterm=none
        # highlight FilterMenuMatch ctermfg=209 cterm=none
        # highlight PopupBorderHighlight ctermfg=244
        # highlight  PmenuKind       ctermfg=246  ctermbg=236   cterm=none
        # highlight! link PmenuKindSel    PmenuSel
        # highlight  PmenuExtra       ctermfg=246  ctermbg=236   cterm=none
        # highlight! link PmenuExtraSel   PmenuSel
        # highlight  Pmenu       ctermfg=none  ctermbg=236   cterm=none
        # highlight  PmenuSel    ctermfg=none  ctermbg=25
        # highlight  PmenuSbar   ctermfg=none  ctermbg=236
        # highlight  PmenuThumb  ctermfg=none  ctermbg=240
        highlight helpCommand ctermfg=248   ctermbg=236
        highlight Statement  cterm=bold ctermfg=253
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
        highlight SpecialKey ctermfg=250
        g:popupthumbhighlight  = 'statuslinenc'
        highlight  user1         cterm=bold,reverse
        highlight  user4         cterm=bold,reverse
        highlight  helpCommand ctermbg=254 ctermfg=240
    endif
    highlight PreProc                  cterm=bold
    highlight helpHeader               cterm=bold
    highlight link helpNote            Normal
    highlight link helpHyperTextEntry Underlined
    highlight link helpHyperTextJump Underlined
    # highlight link manReference Underlined
    # highlight manSectionHeading cterm=bold
    # highlight manSubHeading cterm=bold
    # highlight manOptionDesc cterm=bold
    # highlight manLongOptionDesc cterm=bold
    # highlight manFooter cterm=italic
    # highlight manHeader cterm=italic
    # highlight manCFuncDefinition cterm=bold
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
    highlight PmenuKind ctermfg=246 ctermbg=8 cterm=none
    highlight! link PmenuKindSel PmenuSel
    highlight PmenuExtra ctermfg=246 ctermbg=8 cterm=none
    highlight! link PmenuExtraSel PmenuSel
    highlight Pmenu ctermfg=none ctermbg=8 cterm=none
    # highlight PmenuSel ctermfg=none ctermbg=24
    highlight PmenuSel ctermfg=none ctermbg=58
    highlight PmenuSbar ctermfg=none ctermbg=8
    highlight PmenuThumb ctermfg=none ctermbg=240
    highlight statusline ctermbg=none ctermfg=248 guibg=Grey35 cterm=none
    highlight statuslinenc ctermbg=none ctermfg=242 guibg=Grey35 cterm=none
enddef

def Dracula()
    hi link DevdocLink DraculaLink
    set termguicolors
    # highlight link user1 statusline
    # highlight link user2 statusline
    # highlight link user3 statusline
    # highlight link user4 statusline
enddef

augroup colorschemes | autocmd!
    autocmd ColorScheme quiet Quiet()
    autocmd ColorScheme slate Slate()
    autocmd ColorScheme sorbet Sorbet()
    autocmd ColorScheme dracula Dracula()
augroup END

# NOTE: 'background' is not set correctly until window is opened (after VimEnter). So,
# set the background explicitly so that colorscheme (like 'blue') can choose
# appropriate colors.
# set background=dark
# colorscheme blue

# If env var is set, use it.
if exists("$VIMBG")
    exec $'set background={expandcmd($VIMBG)}'
endif
if exists("$VIMCOLORSCHEME")
    exec $'colorscheme {expandcmd($VIMCOLORSCHEME)}'
endif


# Preview here: https://vimcolorschemes.com/vim/colorschemes (ubunto mono font)

# var curhr = strftime("%H")->str2nr()
# if curhr > 18 || curhr < 8
#     colorscheme blue
# endif

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/
