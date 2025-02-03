vim9script

highlight clear
if exists("syntax_on")
  syntax reset  # Set colors to Vim default
endif
set notermguicolors

g:colors_name = "defaultplus"  # Should be after 'sytax reset' and 'highlight clear'

hi LineNr ctermfg=8
hi link FfTtSubtle Ignore
hi link markdownCodeBlock Constant
hi link PmenuMatch wildmenu
hi MatchParen ctermbg=none cterm=underline
if &bg == 'light'
    hi Type ctermfg=None |# 'Type' is set to green which can be too light
    var bg = hlget('SignColumn')->get(0, {})->get('ctermbg', null_string)
    if (bg != null_string)
        exec $'hi GitGutterAdd ctermbg={bg}'
        exec $'hi GitGutterChange ctermbg={bg}'
        exec $'hi GitGutterDelete ctermbg={bg}'
    endif
    hi Pmenu ctermbg=7
    hi PmenuSel ctermfg=none ctermbg=none cterm=reverse
else
    hi ErrorMsg ctermfg=0
    hi Error ctermfg=0
    hi VimSuggestMute ctermfg=6
    hi Pmenu ctermbg=0 ctermfg=none
    hi PmenuSel ctermfg=none ctermbg=none cterm=reverse
    hi PmenuMatch ctermfg=none ctermbg=8
    var fg = hlget('Pmenu')->get(0, {})->get('ctermfg', null_string)
    if (fg != null_string)
        exec $'hi PmenuSel ctermfg={fg} ctermbg=4'
    endif
endif

# NOTE: Script variables get deleted (Vim bug) when a .vim file is opened after a .c
# file. So, use globals.
g:default_plus_saved_hl = []
g:default_plus_monochrome_applied = false

# Apply monochrome colors if options is set, but exclude help files from
# monochrome treatment.
def ApplyMonochrome()
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
    var saved_hl = g:default_plus_saved_hl
    # All autocommands are applied before reading modelines (where &ft may be
    # set). If &ft is set in modeline monochrome will not be applied.
    if &ft != null_string && &ft !~ 'conf\|help\|markdown\|devdoc\|man'
        if !g:default_plus_monochrome_applied
            for grp in syntax_groups
                var props = saved_hl[saved_hl->match($'^{grp}\s.*')]
                if props !~ 'links to'
                    exec 'hi' grp 'ctermfg=none ctermbg=none cterm=none'
                endif
            endfor
            # hi Operator ctermfg=1
            # hi VimdefBody ctermfg=1
            exec 'hi String' $'ctermfg={&background == "dark" ? 10 : 1}'
            hi! link TabLineFill TabLine
            ## Following works well with 'maple mono' font (https://github.com/comfysage/evergarden)
            ## For light background disable 'semibold' and 'bold' (use 'extrabold'), and use 'medium'
            if &bg == 'dark'
                hi Statement ctermfg=5 cterm=italic
                hi Type ctermfg=5 cterm=italic
            else
                hi Statement ctermfg=4 cterm=bold
                hi Type ctermfg=4 cterm=bold
                hi String ctermfg=2 cterm=bold
            endif
            hi Comment ctermfg=8
            ##
            g:default_plus_monochrome_applied = true
        endif
    elseif g:default_plus_monochrome_applied
        for grp in syntax_groups
            var props = saved_hl[saved_hl->match($'^{grp}\s.*')]
            if props !~ 'links to'
                exec 'hi' props->substitute('\sxxx\s', '', '')
            endif
        endfor
        g:default_plus_monochrome_applied = false
    endif
enddef

if exists("$VIM_MONOCHROME") || get(g:, 'defaut_plus_monochrome', false)
    g:default_plus_saved_hl = 'hi'->execute()->split("\n")
    ApplyMonochrome()
    augroup DefaultPlusMonochrome | autocmd!
        autocmd WinEnter,BufEnter,BufReadPost * ApplyMonochrome()
    augroup END
endif

# vim: sw=4 sts=4 et
