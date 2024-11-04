if !has('vim9script') || v:version < 900
    finish
endif
vim9script

g:colors_name = "ansi16"
highlight clear
if exists("syntax_on")
  syntax reset  # Set colors to Vim default
endif
set notermguicolors

# How:
# - Reset colors to Vim defaults
# - UI elements
#   * Colors 1-6 and 9-14 are only used in ctermfg, not ctermbg
#   * ctermbg colors >0 and <15 are replaced by 256 counterparts
#   * UI elements use 0 (black), 1, 9 (red, bright red), 7 (gray), 8 (dark gray), 15 (white)
#   * It makes sense to keep colors 0, 7, 8, 15, 1, 9 to Ansi defaults
#   * When bg=dark UI elements can use color 7 (light gray) as background
#   * For bg=light ctermbg=15 (lighter gray) works
#   * Colors 1, 9 (red, bright red) used in fg (not bg) in UI elements
#   * Color 8 (dark gray) used for scroll-bar
#   * Color 15 (white) can be used in foreground of UI elements
#   * Color 11 (light yellow) can be used as ctermbg when &bg=light
# - Text colors set to only 0-15 cterm colors
# - Unset guicolors

# ctermbg color replacement
# 0 -> 16 (black)
# 1 -> 231
# 4 -> 26
# 5 -> 128
# 6 -> 32
# 7 -> 250
# 8 -> 240
# 9 -> 196 (bright red)
# 9 -> 124 (red bg)
# 9 -> 160 (red fg)
# 11 -> 214
# 12 -> 32
# 13 -> 92
# 14 -> 39
# 15 -> 254 (very light gray)
#
# 16 -> black
# 231 -> white

if &background ==# 'dark'
    # UI elements
    hi  Pmenu         ctermfg=0     ctermbg=7       cterm=none
    hi  PmenuSel      ctermfg=7     ctermbg=0
    hi  PmenuMatch    ctermfg=1     ctermbg=7       cterm=none
    hi  PmenuMatchSel ctermfg=9     ctermbg=0       cterm=none
    hi  PmenuSbar     ctermfg=8     ctermbg=8
    hi  PmenuThumb    ctermfg=none  ctermbg=0
    hi  PmenuKind     ctermfg=8     ctermbg=7       cterm=none
    hi! link          PmenuKindSel  PmenuSel
    hi  PmenuExtra    ctermfg=8     ctermbg=7       cterm=none
    hi! link          PmenuExtraSel PmenuSel
    hi  LineNr        ctermfg=8
    hi  SignColumn    ctermfg=8     ctermbg=none
    hi  MatchParen    ctermfg=15    ctermbg=8       cterm=bold
    hi  IncSearch     ctermfg=124   ctermbg=15
    hi  StatusLine    ctermfg=0     ctermbg=7       cterm=none
    hi  StatusLineNC  ctermfg=15    ctermbg=none    cterm=underline
    hi  TabLineFill   ctermbg=7     cterm=none
    hi  Search        ctermfg=0     ctermbg=7
    hi  CursorLineNr  ctermfg=none  cterm=underline
    hi  VertSplit     ctermfg=0     ctermbg=7       cterm=none
    hi  ErrorMsg      ctermfg=15    ctermbg=160
    hi  Visual        ctermfg=0
    hi  WildMenu      ctermfg=0     ctermbg=214
    hi  DiffAdd       ctermbg=26
    hi  DiffChange    ctermbg=128
    hi  DiffDelete    ctermfg=0     ctermbg=32
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
    hi  helpCommand ctermfg=7        ctermbg=0
    hi! link        helpHeadline       Title
    hi! link        helpSectionDelim   Comment
    hi! link        helpHyperTextEntry Statement
    hi! link        helpHyperTextJump  Underlined
    hi! link        helpURL            Underlined
else
    # UI elements
    hi  Pmenu         ctermfg=0       ctermbg=15      cterm=none
    hi  PmenuSel      ctermfg=15      ctermbg=0
    hi  PmenuMatch    ctermfg=1       ctermbg=15      cterm=none
    hi  PmenuMatchSel ctermfg=9       ctermbg=0       cterm=none
    hi  PmenuSbar     ctermfg=15      ctermbg=15
    hi  PmenuThumb    ctermfg=none    ctermbg=8
    hi  PmenuKind     ctermfg=8       ctermbg=15      cterm=none
    hi! link          PmenuKindSel    PmenuSel
    hi  PmenuExtra    ctermfg=8       ctermbg=15      cterm=none
    hi! link          PmenuExtraSel   PmenuSel
    hi  LineNr        ctermfg=8
    hi  SignColumn    ctermfg=8       ctermbg=none
    hi  MatchParen    ctermfg=none    ctermbg=15      cterm=bold,underline
    hi  StatusLine    ctermfg=0       ctermbg=7       cterm=none
    hi  StatusLineNC  ctermfg=231     ctermbg=15      cterm=none
    hi  TabLine       cterm=none
    hi  TabLineSel    cterm=underline
    hi  TabLineFill   ctermbg=7       cterm=none
    hi  CursorLineNr  ctermfg=none    cterm=underline
    hi  VertSplit     ctermfg=0       ctermbg=7       cterm=none
    hi  DiffText      ctermfg=231

    # Generic syntax
    hi  Statement  ctermfg=1

    # # Others
    hi  helpExample ctermfg=4
    hi  helpCommand ctermbg=15         ctermfg=8
    hi! link        helpHeadline       Title
    hi! link        helpSectionDelim   Comment
    hi! link        helpHyperTextEntry Statement
    hi! link        helpHyperTextJump  Underlined
    hi! link        helpURL            Underlined
endif

# Apply monochrome colors if variable is set, but exclude help files from
# monochrome.
var saved_hi: list<any>
var monochrome_applied = false
if exists("$VIMMONOCHROME") || get(g:, 'ansi16_monochrome', false)
    saved_hi = 'hi'->execute()->split("\n")
    ApplyMonochrome()
    augroup Ansi16Monochrome | autocmd!
        autocmd FileType * ApplyMonochrome()
    augroup END
endif

var syntaxgrps = [
    'Constant',
    'Special',
    'Identifier',
    'Statement',
    'PreProc',
    'Type',
    'String',
    'Character',
    'Number',
    'Boolean',
    'Float',
    'Function',
    'Conditional',
    'Repeat',
    'Label',
    'Operator',
    'Keyword',
    'Exception',
    'Include',
    'Define',
    'Macro',
    'PreCondit',
    'StorageClass',
    'Structure',
    'Typedef',
    'Tag',
    'SpecialChar',
    'Delimiter',
    'SpecialComment',
    'Debug',
]

def ApplyMonochrome()
    if &ft !~ 'help\|markdown\|devdoc\|man'
        if !monochrome_applied
            for grp in syntaxgrps
                var props = saved_hi[saved_hi->match($'^{grp}\s.*')]
                if props !~ 'links to'
                    exec 'hi' grp 'ctermfg=none ctermbg=none cterm=none'
                endif
            endfor
            monochrome_applied = true
        endif
    elseif monochrome_applied
        for grp in syntaxgrps
            var props = saved_hi[saved_hi->match($'^{grp}\s.*')]
            if props !~ 'links to'
                exec 'hi' props->substitute('\sxxx\s', '', '')
            endif
        endfor
        monochrome_applied = false
    endif
enddef

# vim: sw=4 sts=4 et
