vim9script

# Vim’s default colors are mostly good enough, except for clown colors in popup
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

highlight clear
if exists("syntax_on")
  syntax reset  # Set colors to Vim default
endif
set notermguicolors

g:colors_name = "defaultplus"  # Should be after 'sytax reset' and 'highlight clear'

# var colors = {
#     black: 0,
#     red: 1,
#     green: 2,
#     yellow: 3,
#     blue: 4,
#     magenta: 5,
#     cyan: 6,
#     gray: 7,
#     darkgray: 8,
#     bred: 9,
#     bgreen: 10,
#     byellow: 11,
#     bblue: 12,
#     bmagenta: 13,
#     bcyan: 14,
#     lightgray: 15,
#     rblack: 16,  # Replacement for black
#     rred: 124,
#     rbred: 160,
#     rblue: 26,
#     rmagenta: 128,
#     rcyan: 250,
#     rgray: 250,
#     rdarkgray: 240,
#     rbyellow: 220,
#     rbblue: 32,
#     rbmagenta: 92,
#     rbcyan: 39,
#     rlightgray: 254,
#     rwhite: 231,
#     none: 'none',
# }

# command -nargs=+ -bang HiLight {
#     var grp = <q-args>->matchstr('\s*\zs\S\+')
#     if grp == 'link'
#         :exec $'hi{expand("<bang>")}' <q-args>
#     else
#         var fg = <q-args>->matchstr('ctermfg=\zs\S\+')
#         var bg = <q-args>->matchstr('ctermbg=\zs\S\+')
#         var cterm = <q-args>->matchstr('cterm=\zs\S\+')
#         :exec $'hi{expand("<bang>")}' grp (fg != '' ? $'ctermfg={colors[fg]}' : '')
#                     \ (bg != '' ? $'ctermbg={colors[bg]}' : '')
#                     \ (cterm != '' ? $'cterm={cterm}' : '')
#     endif
# }


# const ansi_default = exists("$VIM_ANSI_DEFAULT") || get(g:, 'defaut_plus_ansi_default', false)

# if &background ==# 'dark'
#     # UI elements
#     HiLight  Pmenu         ctermfg=black      ctermbg=gray      cterm=none
#     HiLight  PmenuSel      ctermfg=rwhite     ctermbg=rblue
#     HiLight  PmenuMatch    ctermfg=rbred      ctermbg=lightgray cterm=none
#     HiLight  PmenuMatchSel ctermfg=rwhite     ctermbg=rbblue    cterm=none
#     HiLight  PmenuSbar     ctermfg=darkgray   ctermbg=darkgray
#     HiLight  PmenuThumb    ctermfg=none       ctermbg=black
#     HiLight  PmenuKind     ctermfg=darkgray   ctermbg=gray      cterm=none
#     HiLight! link          PmenuKindSel       PmenuSel
#     HiLight  PmenuExtra    ctermfg=darkgray   ctermbg=gray      cterm=none
#     HiLight! link          PmenuExtraSel      PmenuSel
#     HiLight  LineNr        ctermfg=darkgray
#     HiLight  SignColumn    ctermfg=darkgray   ctermbg=none
#     HiLight  MatchParen    ctermfg=lightgray  ctermbg=darkgray  cterm=bold
#     HiLight  IncSearch     ctermfg=rbyellow   ctermbg=black
#     HiLight  StatusLine    ctermfg=rwhite     ctermbg=darkgray  cterm=none
#     HiLight  StatusLineNC  ctermfg=darkgray   ctermbg=none      cterm=underline
#     HiLight  TabLineFill   ctermbg=gray       cterm=none
#     HiLight  Search        ctermfg=black      ctermbg=gray
#     HiLight  CursorLineNr  ctermfg=none       cterm=underline
#     HiLight  VertSplit     ctermfg=black      ctermbg=gray      cterm=none
#     HiLight  Visual        ctermfg=lightgray  ctermbg=darkgray
#     HiLight  WildMenu      ctermfg=black      ctermbg=rbyellow
#     HiLight  Folded        ctermfg=bcyan      ctermbg=rdarkgray
#     HiLight  FoldColumn    ctermfg=bcyan      ctermbg=rdarkgray
#     HiLight  DiffAdd       ctermbg=rblue
#     HiLight  DiffChange    ctermbg=rmagenta
#     HiLight  DiffDelete    ctermfg=rblack     ctermbg=rbblue
#     HiLight  DiffText      cterm=bold         ctermbg=rred
#     HiLight  SpellBad      ctermbg=rred
#     HiLight  SpellCap      ctermbg=rblue
#     HiLight  SpellRare     ctermbg=rmagenta
#     HiLight  SpellLocal    ctermfg=black      ctermbg=rbcyan
#     HiLight  ErrorMsg      ctermfg=rlightgray ctermbg=rbred
#     HiLight  MoreMsg       ctermfg=blue

#     # Generic syntax
#     # HiLight  Constant   ctermfg=red  |# default is 13 (bmagenta)
#     if ansi_default
#         HiLight  Comment    ctermfg=darkgray
#     else
#         # Special: default hardcoded to yellow(224)
#         HiLight  Special    ctermfg=red
#         # PreProc: default hardcoded to cyan(81)
#         HiLight  PreProc    ctermfg=red
#         HiLight  Comment    ctermfg=blue
#     endif
#     HiLight  Identifier ctermfg=cyan      cterm=none
#     HiLight  Statement  ctermfg=yellow
#     HiLight  Type       ctermfg=green
#     HiLight  Underlined ctermfg=magenta
#     HiLight  Ignore     ctermfg=black     ctermbg=lightgray
#     HiLight! link       Added             Constant
#     HiLight  Changed    ctermfg=bblue
#     HiLight  Removed    ctermfg=bred
#     HiLight  Error      ctermfg=lightgray ctermbg=rred
#     HiLight  Todo       ctermfg=rblack    ctermbg=rbyellow

#     # Others
#     HiLight  helpExample ctermfg=magenta
#     HiLight  helpCommand ctermfg=gray    ctermbg=black
#     hi link  markdownCodeBlock String

# else  # bg=light

#     # UI elements
#     HiLight  Pmenu         ctermfg=black     ctermbg=lightgray cterm=none
#     HiLight  PmenuSel      ctermfg=lightgray ctermbg=black
#     HiLight  PmenuMatch    ctermfg=red       ctermbg=lightgray cterm=none
#     HiLight  PmenuMatchSel ctermfg=bred      ctermbg=black     cterm=none
#     HiLight  PmenuSbar     ctermfg=lightgray ctermbg=lightgray
#     HiLight  PmenuThumb    ctermfg=none      ctermbg=darkgray
#     HiLight  PmenuKind     ctermfg=darkgray  ctermbg=lightgray cterm=none
#     HiLight! link          PmenuKindSel      PmenuSel
#     HiLight  PmenuExtra    ctermfg=darkgray  ctermbg=lightgray cterm=none
#     HiLight! link          PmenuExtraSel     PmenuSel
#     HiLight  LineNr        ctermfg=darkgray
#     HiLight  SignColumn    ctermfg=darkgray  ctermbg=none
#     HiLight  MatchParen    ctermfg=none      ctermbg=lightgray cterm=bold,underline
#     HiLight  StatusLine    ctermfg=rwhite    ctermbg=darkgray  cterm=none
#     HiLight  StatusLineNC  ctermfg=darkgray  ctermbg=lightgray cterm=none
#     HiLight  TabLine       cterm=none
#     HiLight  TabLineSel    cterm=underline
#     HiLight  TabLineFill   ctermbg=gray      cterm=none
#     HiLight  CursorLineNr  ctermfg=none      cterm=underline
#     HiLight  VertSplit     ctermfg=black     ctermbg=gray      cterm=none

#     # Generic syntax
#     HiLight  Comment    ctermfg=darkgray
#     # HiLight  Statement  ctermfg=blue     cterm=italic
#     HiLight  Statement  ctermfg=none     cterm=bold

#     # Others
#     HiLight  helpExample ctermfg=blue
#     HiLight  helpCommand ctermbg=lightgray ctermfg=darkgray
# endif

hi LineNr ctermfg=8
hi Comment ctermfg=8
hi link FfTtSubtle Ignore
hi link markdownCodeBlock Constant
hi link PmenuMatch wildmenu
hi MatchParen ctermbg=none cterm=underline
if &bg == 'light'
    hi Type ctermfg=None |# 'Type' is set to green which can be too light
    hi PmenuSel ctermfg=15 ctermbg=4
    var bg = hlget('SignColumn')->get(0, {})->get('ctermbg', null_string)
    if (bg != null_string)
        exec $'hi GitGutterAdd ctermbg={bg}'
        exec $'hi GitGutterChange ctermbg={bg}'
        exec $'hi GitGutterDelete ctermbg={bg}'
    endif
else
    hi ErrorMsg ctermfg=0
    # Less bright menu
    hi Pmenu ctermfg=15 ctermbg=8
    hi PmenuSel ctermfg=0 ctermbg=4
    hi PmenuMatch ctermfg=15 ctermbg=0
    hi VimSuggestMute ctermfg=6
endif

# Apply monochrome colors if options is set, but exclude help files from
# monochrome treatment.
const syntax_groups = [
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
    # All autocommands are applied before reading modelines (where &ft may be
    # set).
    if &ft != null_string && &ft !~ 'conf\|help\|markdown\|devdoc\|man'
        if !monochrome_applied
            for grp in syntax_groups
                var props = saved_hi[saved_hi->match($'^{grp}\s.*')]
                if props !~ 'links to'
                    exec 'hi' grp 'ctermfg=none ctermbg=none cterm=none'
                endif
            endfor
            hi Operator ctermfg=1
            hi VimdefBody ctermfg=1
            exec 'hi String' $'ctermfg={&background == "dark" ? 10 : 1}'
            hi! link TabLineFill TabLine
            ## Following works well with 'maple mono' font (https://github.com/comfysage/evergarden)
            hi Statement ctermfg=5 cterm=italic
            hi Type ctermfg=5 cterm=italic
            ##
            monochrome_applied = true
        endif
    elseif monochrome_applied
        for grp in syntax_groups
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
        autocmd WinEnter,BufReadPost * ApplyMonochrome()
    augroup END
endif

# delcommand HiLight

# vim: sw=4 sts=4 et
