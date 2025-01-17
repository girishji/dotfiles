vim9script

highlight clear
if exists("syntax_on")
  syntax reset  # Set colors to Vim default
endif
set notermguicolors

g:colors_name = "defaultplus"  # Should be after 'sytax reset' and 'highlight clear'

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
    var fg = hlget('Pmenu')->get(0, {})->get('ctermfg', null_string)
    exec $'hi PmenuSel ctermfg={fg} ctermbg=4'
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
    # set). If &ft is set in modeline monochrome will not be applied.
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

# vim: sw=4 sts=4 et
