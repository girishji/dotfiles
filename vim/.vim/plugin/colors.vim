vim9script

# colorscheme is not needed. Adjust terminal colors.
# When ssh or lldb, new window has 'light' as 'background'. Do not use 'dark'
# background for 'midnight commander' like colors.
# Modify colors for source files and leave defaults for help/markdown files.
if get(g:, 'colors_name', null_string) == null_string
    augroup ColorMonochrome | autocmd!
        # autocmd TermResponseAll background call SaneColors() | redraw
        # FileType event is not called every time buffer is switched.
        # BufReadPost will not have &filetype. So defer until filetype
        # is detected.
        autocmd WinEnter,BufEnter,BufReadPost * call timer_start(10, (_) => ApplyColors())
    augroup END
endif

def ApplyColors()
    if &filetype !~ 'help\|markdown'
        # XXX: Do not use 15. When --clean both error and errormsg have
        # ctermfg=15. Leave them unchanged, otherwise errors are not visible.
        # XXX: Changing color of 'bold' fonts through terminal messess up
        # color of statusline.
        hi Type ctermfg=12 cterm=bold
        hi! link Statement Type
        hi! link Identifier Type
        hi Operator ctermfg=None
        hi Comment ctermfg=14 cterm=italic
        hi String ctermfg=13 cterm=none
        hi Special ctermfg=13
        hi Constant ctermfg=13 cterm=none
        hi PreProc ctermfg=13 cterm=bold
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

def SaneColors()
    # XXX: Do not use 15. When --clean both error and errormsg have
    # ctermfg=15. Leave them unchanged, otherwise errors are not visible.

    hi Added          ctermfg=4
    hi ColorColumn ctermbg=9
    hi DiffAdd ctermfg=8
    hi DiffChange ctermbg=9
    hi DiffDelete ctermfg=8
    hi FoldColumn ctermbg=0
    hi Folded ctermbg=0
    hi LineNr ctermfg=11 ctermbg=0
    hi NonText ctermfg=0 |# 'eol', etc.
    hi Pmenu          ctermfg=8 ctermbg=6 cterm=bold
    hi PmenuExtra     ctermfg=7 ctermbg=6 cterm=bold
    hi PmenuExtraSel  ctermfg=7 ctermbg=2 cterm=bold
    hi PmenuMatch     ctermfg=1 ctermbg=6 cterm=bold
    hi PmenuMatchSel  ctermfg=1 ctermbg=2 cterm=bold
    hi PmenuSbar      ctermbg=7
    hi PmenuSel       ctermfg=8 ctermbg=2 cterm=bold
    hi PmenuThumb     ctermbg=8
    hi Search ctermfg=0 ctermbg=3
    hi SignColumn ctermfg=None ctermbg=0
    hi StatusLine     ctermfg=8 ctermbg=6 cterm=bold
    hi TabLine ctermfg=8 ctermbg=11 cterm=none
    hi TabLineFill cterm=none ctermbg=0 ctermfg=none
    hi TabLineSel ctermbg=none ctermfg=none cterm=bold,reverse
    hi VertSplit      ctermfg=6
    hi link StatusLineTermNC StatusLineNC
    hi! link StatusLineNC StatusLine
    hi! link StatusLineTerm StatusLine

    hi MatchParen ctermfg=5 ctermbg=none cterm=underline
    hi Todo ctermfg=none ctermbg=none cterm=reverse,bold
    hi SpecialKey ctermfg=10 |# 'tab', 'nbsp', 'space', ctrl chars (^a, ^b, etc.)
    hi! link EndOfBuffer SpecialKey |# '~' at the beginning of empty lines
enddef

# Following should occur after setting colorscheme.
highlight! TrailingWhitespace ctermbg=196
match TrailingWhitespace /\s\+\%#\@<!$/

# vim: ts=4 shiftwidth=4 sts=4 expandtab
