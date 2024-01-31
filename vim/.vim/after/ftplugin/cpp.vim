vim9script

setl path-=/usr/include

# cppman to view cppreference.com documentation
command -complete=custom,ListCppKeywords -nargs=1 Cppman :term ++close cppman <args>
def ListCppKeywords(ArgLead: string, CmdLine: string, CursorPos: number): string
    return system($'cppman -f {ArgLead}')
enddef

nnoremap <buffer> <leader>H :Cppman<space>
cabbr <expr> hh  abbr#ExpandCmd('hh') ? 'Cppman <c-r>=abbr#Eatchar()<cr>' : 'hh'

if exists("g:loaded_vimcomplete")
    g:VimCompleteOptionsSet({
        lsp: { enable: true, maxCount: 50, priority: 11 },
    })
endif
