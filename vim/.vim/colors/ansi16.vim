if !has('vim9script') || v:version < 900
    finish
endif
vim9script

# How:
# - Reset colors to Vim defaults
# - UI elements background colors (0-15) replaced by closest 16-255
#   * Replace only if bg color is not gray (7) and not >15
# - Text colors set to only 0-15 cterm colors
# - Clown colors (Pmenu, etc.) replaced with something more muted
# - Unset guicolors

g:colors_name = "ansi16"
highlight clear
if exists("syntax_on")
  syntax reset  # Set colors to Vim default
endif
set notermguicolors

# ctermbg color replacement for &bg=dark
# 0 -> 16 (accurate black)
# 1 -> 231
# 4 -> 26
# 5 -> 128
# 6 -> 32
# 7 -> 250
# 8 -> 240
# 9 -> 196 (accurate red)
# 9 -> 124 (red bg)
# 9 -> 160 (red fg)
# 11 -> 214
# 12 -> 32
# 13 -> 92
# 14 -> 39
# 15 -> 231 (accurate white)
#
# 213 for Pmenu background (when &bg=dark) is close to default
# 176 for PmenuSbar matches 213 above

if &background ==# 'dark'
    # UI elements
    hi  Pmenu         ctermfg=16    ctermbg=250  cterm=none
    hi  PmenuSel      ctermfg=250   ctermbg=16
    hi  PmenuMatch    ctermfg=124   ctermbg=250  cterm=none
    hi  PmenuMatchSel ctermfg=202   ctermbg=16   cterm=none
    hi  PmenuSbar     ctermfg=248   ctermbg=248
    hi  PmenuThumb    ctermfg=none  ctermbg=232
    hi  PmenuKind     ctermfg=240   ctermbg=250  cterm=none
    hi! link          PmenuKindSel  PmenuSel
    hi  PmenuExtra    ctermfg=240   ctermbg=250  cterm=none
    hi! link          PmenuExtraSel PmenuSel
    hi  LineNr        ctermfg=240
    hi  MatchParen    ctermfg=none  ctermbg=none cterm=underline
    hi  IncSearch     ctermfg=124   ctermbg=231
    hi  StatusLine    ctermfg=16    ctermbg=250  cterm=none
    hi  StatusLineNC  ctermfg=231   ctermbg=none cterm=underline
    hi  SignColumn    ctermfg=240   ctermbg=none
    hi  TabLineFill   ctermbg=250   cterm=none
    hi  Search        ctermfg=16    ctermbg=250
    hi  CursorLineNr  ctermfg=none               cterm=underline
    hi  VertSplit     ctermfg=16    ctermbg=250  cterm=none
    hi  ErrorMsg      ctermfg=231   ctermbg=160
    hi  Visual        ctermfg=16
    hi  WildMenu      ctermfg=16    ctermbg=214
    hi  DiffAdd       ctermbg=26
    hi  DiffChange    ctermbg=128
    hi  DiffDelete    ctermfg=16    ctermbg=32
    hi  DiffText      cterm=bold    ctermbg=124
    hi  SpellBad      ctermbg=124
    hi  SpellCap      ctermbg=26
    hi  SpellRare     ctermbg=92
    hi  SpellLocal    ctermbg=39

    # Generic syntax
    hi  Comment    ctermfg=8
    hi  Identifier cterm=none
    hi  Underlined ctermfg=6
    hi  Type       ctermfg=10
    hi  Statement  ctermfg=11
    hi  Constant   ctermfg=13
    hi  Special    ctermfg=3
    hi  PreProc    ctermfg=14
    hi  Todo       ctermfg=15 ctermbg=NONE cterm=bold,underline
    hi! link       Error      ErrorMsg

    # Others
    hi  helpExample ctermfg=5
    hi  helpCommand ctermfg=248        ctermbg=235
    hi! link        helpHeadline       Title
    hi! link        helpSectionDelim   Comment
    hi! link        helpHyperTextEntry Statement
    hi! link        helpHyperTextJump  Underlined
    hi! link        helpURL            Underlined
else

    hi helpCommand     ctermbg=254 ctermfg=240
endif

var saved_hi: list<any>

def ApplyMonochrome()
enddef

if exists("$VIMMONOCHROME")
    saved_hi = 'hi'->execute()->split("\n")
endif

# def Clear()
#     for grp in [
#             'Normal',
#             'Comment',
#             ]
#         exec $'hi {grp} ctermfg=none ctermbg=none cterm=none'
#     endfor
# enddef
# Clear()

# if &background ==# 'dark'
#     hi Comment ctermfg=8
#     hi Pmenu ctermfg=0 ctermbg=7 cterm=none
#     hi PmenuSel ctermfg=7 ctermbg=0
#     hi PmenuMatch ctermfg=1 ctermbg=7 cterm=none
#     hi PmenuMatchSel ctermfg=9 ctermbg=0 cterm=none
#     hi PmenuSbar ctermfg=7 ctermbg=7
#     hi PmenuThumb ctermfg=none ctermbg=8
#     hi PmenuKind ctermfg=8 ctermbg=7 cterm=none
#     hi! link PmenuKindSel PmenuSel
#     hi PmenuExtra ctermfg=8 ctermbg=7 cterm=none
#     hi! link PmenuExtraSel PmenuSel
#     hi LineNr ctermfg=8
#     hi MatchParen ctermfg=0 ctermbg=7
#     hi IncSearch ctermfg=9 ctermbg=15
#     hi StatusLine ctermfg=0 ctermbg=7 cterm=none
#     hi StatusLineNC ctermfg=15 ctermbg=none cterm=underline
#     hi SignColumn ctermfg=8 ctermbg=none
#     hi TabLineFill ctermbg=7 cterm=none
#     hi Search ctermfg=0 ctermbg=7
#     hi CursorLineNr ctermfg=none cterm=underline
#     hi VertSplit ctermfg=0 ctermbg=7 cterm=none
# else
#     hi Comment ctermfg=7
# endif

# hi TabLineSel cterm=bold,reverse





def ColorLinkedGroups()
    var qfg = &background ==# 'dark' ? 253 : 16
    var qbg = &background ==# 'dark' ? 16 : 188
    for hg in execute('highlight')->split("\n")
        var items = hg->split()
        var fgidx = items->index($'ctermfg={qfg}')
        var bgidx = items->index($'ctermbg={qbg}')
        if fgidx != -1 || bgidx != -1
            exec $'hi {items[0]} {fgidx != -1 ? "ctermfg=none" : ""} {bgidx != -1 ? "ctermbg=none" : ""}'
        endif
    endfor
enddef


# highlight helpExample ctermfg=248
#     highlight helpCommand ctermfg=248 ctermbg=235

#     highlight CursorLine ctermfg=NONE ctermbg=8 cterm=NONE

#     highlight Pmenu ctermfg=254 ctermbg=238 cterm=none
#     highlight PmenuMatch ctermfg=220 ctermbg=238 cterm=none
#     highlight PmenuMatchSel ctermfg=220 ctermbg=243 cterm=none
#     highlight PmenuSel ctermfg=none ctermbg=243
#     highlight PmenuSbar ctermfg=254 ctermbg=236
#     highlight PmenuThumb ctermfg=none ctermbg=243
#     highlight PmenuKind ctermfg=246 ctermbg=238 cterm=none
#     highlight! link PmenuKindSel PmenuSel
#     highlight PmenuExtra ctermfg=246 ctermbg=238 cterm=none
#     highlight! link PmenuExtraSel PmenuSel

# vim: sw=4 sts=4 et
