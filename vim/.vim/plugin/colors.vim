vim9script

if has('gui')  # MacVim
    finish
endif

# NOTE: 'background' is not set correctly until window is opened (after VimEnter). So,
# set the background explicitly so that colorscheme can choose appropriate colors.

# If env var is set, use it.
if expandcmd($VIM_BG) != null_string
    exec $'set background={expandcmd($VIM_BG)}'
endif

# color 146 -> slightly blue but gray
# color 249 -> gray replacement for 146
autocmd ColorScheme quiet {
    # hi Comment ctermfg=246 cterm=none
    # hi LineNr ctermfg=243
    # hi Type cterm=bold ctermfg=249
    # hi Statement cterm=bold ctermfg=249
    # hi Identifier cterm=bold ctermfg=249
    # hi String cterm=italic
    # hi Special cterm=italic
    # hi Constant cterm=italic
    # hi PreProc cterm=italic

    # hi Type cterm=bold ctermfg=146
    # hi Statement cterm=bold ctermfg=146
    # hi Identifier cterm=bold ctermfg=146
    # hi String ctermfg=146
    # hi Special ctermfg=146
    # hi Constant ctermfg=146
    # hi PreProc ctermfg=146
}
if expandcmd($VIM_COLORSCHEME) != null_string
    exec $'colorscheme {expandcmd($VIM_COLORSCHEME)}'
endif

# colorscheme is not needed. Adjust terminal colors.
# Modify colors for source files and leave defaults for help/markdown files.
if get(g:, 'colors_name', null_string) == null_string
    augroup ColorMonochrome | autocmd!
        # FileType event is not called every time buffer is switched.
        # BufReadPost will not have &filetype. So defer until filetype
        # is detected.
        autocmd WinEnter,BufEnter,BufReadPost * call timer_start(10, (_) => ApplyColors())
        autocmd OptionSet background ApplyColors()
    augroup END
endif

def SaneColors()
    if &bg == 'light'
        hi SignColumn ctermfg=None ctermbg=7
        hi LineNr ctermfg=11 ctermbg=7
        hi TabLine ctermfg=none ctermbg=7 cterm=none
        hi TabLineFill cterm=none ctermbg=none ctermfg=none
        hi TabLineSel ctermbg=none ctermfg=none cterm=bold,reverse
        hi Pmenu ctermfg=2 ctermbg=7
        hi PmenuMatch ctermfg=5 ctermbg=7
        hi PmenuSel ctermfg=7 ctermbg=8
        hi PmenuMatchSel ctermfg=7 ctermbg=8 cterm=underline
        hi NonText ctermfg=7 |# 'eol', etc.
        hi Search ctermfg=7 ctermbg=12
        hi DiffText ctermfg=15
        hi StatusLine ctermfg=none ctermbg=none cterm=bold,reverse
        hi StatusLineNC ctermfg=none ctermbg=7 cterm=none
        hi StatusLineTerm ctermfg=none ctermbg=7 cterm=bold
        hi link StatusLineTermNC StatusLineNC
        # hi StatusLine ctermfg=none ctermbg=7 cterm=bold
        # hi StatusLineNC ctermfg=12 ctermbg=none cterm=italic
        # hi StatusLineTerm ctermfg=3 ctermbg=7 cterm=none
        # hi StatusLineTermNC ctermfg=14 ctermbg=0 cterm=italic
        hi Cursorline ctermbg=7 cterm=none
        hi! link CursorlineNr Cursorline
        set cursorline
    else  # dark
        hi SignColumn ctermfg=None ctermbg=0
        hi LineNr ctermfg=11 ctermbg=0
        # hi TabLine ctermfg=12 ctermbg=0
        # hi TabLineFill cterm=none ctermbg=0
        # hi TabLineSel ctermbg=none ctermfg=none cterm=bold,underline
        hi TabLine ctermfg=none ctermbg=0 cterm=none
        hi TabLineFill cterm=none ctermbg=none ctermfg=none
        hi TabLineSel ctermbg=none ctermfg=none cterm=bold,reverse
        hi Pmenu ctermfg=2 ctermbg=0
        hi PmenuMatch ctermfg=3
        hi PmenuSel ctermfg=8 ctermbg=7
        hi PmenuMatchSel ctermfg=8 ctermbg=7 cterm=underline
        hi PmenuSbar ctermbg=0
        hi PmenuThumb ctermbg=7
        hi NonText ctermfg=0 |# 'eol', etc.
        hi Search ctermfg=0 ctermbg=12
        # hi StatusLine ctermfg=none ctermbg=0 cterm=bold
        # hi StatusLineNC ctermfg=12 ctermbg=none cterm=italic
        # hi StatusLineTerm ctermfg=3 ctermbg=0 cterm=none
        # hi StatusLineTermNC ctermfg=14 ctermbg=none cterm=italic
        hi StatusLine ctermfg=none ctermbg=none cterm=bold,reverse
        hi StatusLineNC ctermfg=none ctermbg=0 cterm=none
        hi StatusLineTerm ctermfg=none ctermbg=0 cterm=bold
        hi link StatusLineTermNC StatusLineNC
        hi ErrorMsg ctermbg=9
        hi ColorColumn ctermbg=9
        hi DiffChange ctermbg=9
        hi DiffAdd ctermfg=8
        hi DiffDelete ctermfg=8
        hi Folded ctermfg=15
        hi FoldColumn ctermfg=15
    endif
    hi MatchParen ctermfg=1 ctermbg=none cterm=underline
    # hi Todo ctermfg=0 ctermbg=1
    hi Todo ctermfg=none ctermbg=none cterm=reverse,bold
    hi SpecialKey ctermfg=10 |# 'tab', 'nbsp', 'space', ctrl chars (^a, ^b, etc.)

    var bg = hlget('SignColumn')->get(0, {})->get('ctermbg', null_string)
    if (bg != null_string)
        exec $'hi GitGutterAdd ctermbg={bg}'
        exec $'hi GitGutterChange ctermbg={bg}'
        exec $'hi GitGutterDelete ctermbg={bg}'
    endif
enddef

# def ApplyMonochrome()
#     exec $"source $VIMRUNTIME/colors/quiet.vim"
#     var replace = {
#         bg: {
#             16: 'none',
#             253: 'none',
#             242: '14',
#             214: '3',
#             248: '11',
#             240: '10',
#         },
#         fg:  {
#             253: 'none',
#             242: '14',
#             214: '3',
#             248: '11',
#             240: '10',
#         }
#     }
#     for hg in execute('highlight')->split("\n")
#         var items = hg->split()
#         for surf in ['bg', 'fg']
#             for k in replace[surf]->keys()
#                 var idx = items->index($'cterm{surf}={k}')
#                 if idx != -1
#                     exec $'hi {items[0]} cterm{surf}={replace[surf][k]}'
#                     break
#                 endif
#             endfor
#         endfor
#     endfor
# enddef

def ApplyColors()
    var monochrome = expandcmd($VIM_MONOCHROME) != null_string
    # if monochrome
    #     ApplyMonochrome()
    #     if &filetype =~ 'help\|markdown'
    #         hi Constant ctermfg=4
    #         hi String ctermfg=6
    #         hi Statement ctermfg=2
    #         hi Identifier ctermfg=4 cterm=none
    #         hi PreProc ctermfg=1
    #         hi Special ctermfg=1
    #         hi Type ctermfg=3
    #     endif
    # else
    #     SaneColors()
    # endif
    if &filetype !~ 'help\|markdown' && monochrome
        # Change color of 'bold' fonts throug terminal.
        hi Type ctermfg=None cterm=bold
        hi Statement ctermfg=None cterm=bold
        hi Identifier ctermfg=None cterm=bold
        hi Operator ctermfg=None
        hi Comment ctermfg=14 cterm=none
        hi String ctermfg=13 cterm=none
        hi Special ctermfg=13
        hi Constant ctermfg=13 cterm=none
        hi PreProc ctermfg=13 cterm=none
    else
        syntax reset
        hi link StatusLineNC StatusLine
        hi Constant ctermfg=4
        hi String ctermfg=6
        hi Statement ctermfg=2
        hi Identifier ctermfg=4 cterm=none
        hi PreProc ctermfg=1
        hi Special ctermfg=1
        hi Type ctermfg=3
    endif
    SaneColors()
enddef

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/
