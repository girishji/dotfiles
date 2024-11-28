vim9script

# Vim’s default colors are mostly excellent, except for clown colors in popup
# menus and certain UI background colors that lack contrast.
# - Set UI element backgrounds (e.g., popup menu) to terminal gray: use
#   `ctermbg` 7 for dark (`&bg=dark`) and 15 for light (`&bg=light`)
#   backgrounds. Customize these settings in the terminal app if needed.
# - Restrict general syntax colors to 1-6 for consistency and readability.
# - Terminal apps like `ls` and `git diff` use all colors (1-6 and 9-15) for
#   foregrounds, but Vim uses 9-15 as backgrounds, causing compatibility issues.
#   To resolve this, set background colors to the closest ANSI defaults where
#   necessary.
# - Default ANSI16 colors (especially 1-6) are unsuitable as foregrounds on
#   black background; However, they work fine on white background ('Basic'
#   profile of terminal app).

g:colors_name = "defaultplus"
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
    Hi  StatusLine    ctermfg=rwhite     ctermbg=darkgray  cterm=none
    Hi  StatusLineNC  ctermfg=darkgray   ctermbg=none      cterm=underline
    # Hi  StatusLine    ctermfg=black      ctermbg=gray      cterm=none
    # Hi  StatusLineNC  ctermfg=lightgray  ctermbg=none      cterm=underline
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
    Hi  SpellLocal    ctermfg=black      ctermbg=rbcyan
    Hi  ErrorMsg      ctermfg=rlightgray ctermbg=rbred
    Hi  MoreMsg       ctermfg=blue

    # Generic syntax
    Hi  Comment    ctermfg=blue
    Hi  Constant   ctermfg=red
    Hi  Special    ctermfg=red
    Hi  Identifier ctermfg=cyan      cterm=none
    Hi  Statement  ctermfg=yellow
    # Hi  PreProc    ctermfg=magenta
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
    Hi  Pmenu         ctermfg=black     ctermbg=lightgray cterm=none
    Hi  PmenuSel      ctermfg=lightgray ctermbg=black
    Hi  PmenuMatch    ctermfg=red       ctermbg=lightgray cterm=none
    Hi  PmenuMatchSel ctermfg=bred      ctermbg=black     cterm=none
    Hi  PmenuSbar     ctermfg=lightgray ctermbg=lightgray
    Hi  PmenuThumb    ctermfg=none      ctermbg=darkgray
    Hi  PmenuKind     ctermfg=darkgray  ctermbg=lightgray cterm=none
    Hi! link          PmenuKindSel      PmenuSel
    Hi  PmenuExtra    ctermfg=darkgray  ctermbg=lightgray cterm=none
    Hi! link          PmenuExtraSel     PmenuSel
    Hi  LineNr        ctermfg=darkgray
    Hi  SignColumn    ctermfg=darkgray  ctermbg=none
    Hi  MatchParen    ctermfg=none      ctermbg=lightgray cterm=bold,underline
    Hi  StatusLine    ctermfg=black     ctermbg=gray      cterm=none
    Hi  StatusLineNC  ctermfg=darkgray  ctermbg=lightgray cterm=none
    Hi  TabLine       cterm=none
    Hi  TabLineSel    cterm=underline
    Hi  TabLineFill   ctermbg=gray      cterm=none
    Hi  CursorLineNr  ctermfg=none      cterm=underline
    Hi  VertSplit     ctermfg=black     ctermbg=gray      cterm=none

    # Generic syntax
    Hi  Comment    ctermfg=darkgray
    # Hi  Statement  ctermfg=blue     cterm=italic
    Hi  Statement  ctermfg=none     cterm=bold

    # Others
    Hi  helpExample ctermfg=blue
    Hi  helpCommand ctermbg=lightgray ctermfg=darkgray
endif

delcommand Hi

# Apply monochrome colors if options is set, but exclude help files from
# monochrome treatment.
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
            hi Operator ctermfg=magenta
            hi String   ctermfg=green
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
if exists("$VIM_MONOCHROME") || get(g:, 'defaut_plus_monochrome', false)
    saved_hi = 'hi'->execute()->split("\n")
    ApplyMonochrome()
    augroup DefaultPlusMonochrome | autocmd!
        autocmd WinEnter,BufEnter * ApplyMonochrome()
    augroup END
endif

# vim: sw=4 sts=4 et
