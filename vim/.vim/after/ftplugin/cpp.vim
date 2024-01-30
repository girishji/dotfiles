vim9script

# cppman to view cppreference.com documentation
command -complete=custom,ListCppKeywords -nargs=1 Cppman :term ++close cppman <args>
def ListCppKeywords(ArgLead: string, CmdLine: string, CursorPos: number): string
    return system($'cppman -f {ArgLead}')
enddef

nnoremap <buffer> <leader>H :Cppman<space>

