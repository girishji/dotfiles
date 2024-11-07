if !has('vim9script') || v:version < 900
    finish
endif
vim9script

# Terminal apps provide 16 configurable colors, in addition to background and foreground color.
# These colors are associated with ANSI 16 colors from the past, which had
# specific RGB values. These values are now termed 'ANSI Default'.
# The problem with associating syntax highlighting to ANSI colors is that some
# of the colors from 1-6 of ANSI defaults are not suitable for black background. If the brighter
# counterparts (9-14) are chosen then colors from other profiles in terminal app do not look good.
# The solution is to provide an
# option to switch to brighter colors (for code syntax) only when appropriate.
# UI elements use background colors extensively. If we limit ourselves to using only 0-15 then
# some colors will get used as foreground in code syntax as well as background
# in UI elements. This is not workable. The solution is to use only 7, 8, 15 for
# UI background colors. In case colored background is needed it will be chosen from
# 16-255, and these elements thus can only be configured explicitly through
# `highlight` command, while not settable in terminal app. Finally, provide a
# monochrome option for code syntax, and exclude help files from monochrome treatment.

g:colors_name = "sixteen"
highlight clear
if exists("syntax_on")
  syntax reset  # Set colors to Vim default
endif
set notermguicolors

var colors = {
    black: 0,
    red: 1,
    green: 2,
    yellow: 3,
    blue: 4,
    magenta: 5,
    cyan: 6,
    gray: 7,
    darkgray: 8,
    bred: 9,
    bgreen: 10,
    byellow: 11,
    bblue: 12,
    bmagenta: 13,
    bcyan: 14,
    lightgray: 15,
    rblack: 16,  # Replacement for black
    rred: 124,
    rbred: 160,
    rblue: 26,
    rmagenta: 128,
    rcyan: 250,
    rgray: 250,
    rdarkgray: 240,
    rbyellow: 220,
    rbblue: 32,
    rbmagenta: 92,
    rbcyan: 39,
    rlightgray: 254,
    rwhite: 231,
    none: 'none',
}

if exists("$SIXTEENBRIGHT") || get(g:, 'sixteen_bright', false)
    for c in ['red', 'green', 'yellow', 'blue', 'magenta', 'cyan']
        colors[c] += 8
    endfor
endif

command -nargs=+ -bang Hi {
    var grp = <q-args>->matchstr('\s*\zs\S\+')
    if grp == 'link'
        :exe $'hi{expand("<bang>")}' <q-args>
    else
        var fg = <q-args>->matchstr('ctermfg=\zs\S\+')
        var bg = <q-args>->matchstr('ctermbg=\zs\S\+')
        var cterm = <q-args>->matchstr('cterm=\zs\S\+')
        :exe $'hi{expand("<bang>")}' grp (fg != '' ? $'ctermfg={colors[fg]}' : '')
                    \ (bg != '' ? $'ctermbg={colors[bg]}' : '')
                    \ (cterm != '' ? $'cterm={cterm}' : '')
    endif
}


if &background ==# 'dark'
    # UI elements
    Hi  Pmenu         ctermfg=black      ctermbg=gray      cterm=none
    Hi  PmenuSel      ctermfg=gray       ctermbg=black
    Hi  PmenuMatch    ctermfg=rbred      ctermbg=lightgray cterm=none
    Hi  PmenuMatchSel ctermfg=bred       ctermbg=black     cterm=none
    Hi  PmenuSbar     ctermfg=darkgray   ctermbg=darkgray
    Hi  PmenuThumb    ctermfg=none       ctermbg=black
    Hi  PmenuKind     ctermfg=darkgray   ctermbg=gray      cterm=none
    Hi! link          PmenuKindSel       PmenuSel
    Hi  PmenuExtra    ctermfg=darkgray   ctermbg=gray      cterm=none
    Hi! link          PmenuExtraSel      PmenuSel
    Hi  LineNr        ctermfg=darkgray
    Hi  SignColumn    ctermfg=darkgray   ctermbg=none
    Hi  MatchParen    ctermfg=lightgray  ctermbg=darkgray  cterm=bold
    Hi  IncSearch     ctermfg=rbyellow   ctermbg=black
    Hi  StatusLine    ctermfg=black      ctermbg=gray      cterm=none
    Hi  StatusLineNC  ctermfg=lightgray  ctermbg=none      cterm=underline
    Hi  TabLineFill   ctermbg=gray       cterm=none
    Hi  Search        ctermfg=black      ctermbg=gray
    Hi  CursorLineNr  ctermfg=none       cterm=underline
    Hi  VertSplit     ctermfg=black      ctermbg=gray      cterm=none
    Hi  Visual        ctermfg=lightgray  ctermbg=darkgray
    Hi  WildMenu      ctermfg=black      ctermbg=rbyellow
    Hi  Folded        ctermfg=bcyan      ctermbg=rdarkgray
    Hi  FoldColumn    ctermfg=bcyan      ctermbg=rdarkgray
    Hi  DiffAdd       ctermbg=rblue
    Hi  DiffChange    ctermbg=rmagenta
    Hi  DiffDelete    ctermfg=rblack     ctermbg=rbblue
    Hi  DiffText      cterm=bold         ctermbg=rred
    Hi  SpellBad      ctermbg=rred
    Hi  SpellCap      ctermbg=rblue
    Hi  SpellRare     ctermbg=rmagenta
    Hi  SpellLocal    ctermbg=rbcyan
    Hi  ErrorMsg      ctermfg=rlightgray ctermbg=rbred
    Hi  MoreMsg       ctermfg=blue

    # Generic syntax
    Hi  Comment    ctermfg=blue
    Hi  Constant   ctermfg=red
    Hi  Special    ctermfg=red
    Hi  Identifier ctermfg=cyan      cterm=none
    Hi  Statement  ctermfg=yellow
    Hi  PreProc    ctermfg=magenta
    Hi  Type       ctermfg=green
    Hi  Underlined ctermfg=magenta
    Hi  Ignore     ctermfg=black     ctermbg=lightgray
    Hi! link       Added             Constant
    Hi  Changed    ctermfg=bblue
    Hi  Removed    ctermfg=bred
    Hi  Error      ctermfg=lightgray ctermbg=rred
    Hi  Todo       ctermfg=rblack    ctermbg=rbyellow

    # Others
    Hi  helpExample ctermfg=magenta
    Hi  helpCommand ctermfg=gray    ctermbg=black

else  # bg=light

    # UI elements
    Hi  Pmenu         ctermfg=black       ctermbg=lightgray      cterm=none
    Hi  PmenuSel      ctermfg=lightgray      ctermbg=black
    Hi  PmenuMatch    ctermfg=red       ctermbg=lightgray      cterm=none
    Hi  PmenuMatchSel ctermfg=bred       ctermbg=black       cterm=none
    Hi  PmenuSbar     ctermfg=lightgray      ctermbg=lightgray
    Hi  PmenuThumb    ctermfg=none    ctermbg=darkgray
    Hi  PmenuKind     ctermfg=darkgray       ctermbg=lightgray      cterm=none
    Hi! link          PmenuKindSel    PmenuSel
    Hi  PmenuExtra    ctermfg=darkgray       ctermbg=lightgray      cterm=none
    Hi! link          PmenuExtraSel   PmenuSel
    Hi  LineNr        ctermfg=darkgray
    Hi  SignColumn    ctermfg=darkgray       ctermbg=none
    Hi  MatchParen    ctermfg=none    ctermbg=lightgray      cterm=bold,underline
    Hi  StatusLine    ctermfg=black       ctermbg=gray       cterm=none
    Hi  StatusLineNC  ctermfg=rwhite     ctermbg=lightgray      cterm=none
    Hi  TabLine       cterm=none
    Hi  TabLineSel    cterm=underline
    Hi  TabLineFill   ctermbg=gray       cterm=none
    Hi  CursorLineNr  ctermfg=none    cterm=underline
    Hi  VertSplit     ctermfg=black       ctermbg=gray       cterm=none

    # Generic syntax
    # hi  Statement  ctermfg=1
    hi  Statement  ctermfg=none cterm=bold

    # Others
    Hi  helpExample ctermfg=blue
    Hi  helpCommand ctermbg=lightgray ctermfg=darkgray
endif

hi! link        helpHeadline       Title
hi! link        helpSectionDelim   Comment
hi! link        helpHyperTextEntry Statement
hi! link        helpHyperTextJump  Underlined
hi! link        helpURL            Underlined

delcommand Hi

# Apply monochrome colors if variable is set, but exclude help files from
# monochrome.
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

var saved_hi: list<any>
var monochrome_applied = false
if exists("$SIXTEEN_MONOCHROME") || get(g:, 'sixteen_monochrome', false)
    saved_hi = 'hi'->execute()->split("\n")
    ApplyMonochrome()
    augroup SixteenMonochrome | autocmd!
        autocmd WinEnter,BufEnter * ApplyMonochrome()
    augroup END
endif

# vim: sw=4 sts=4 et
