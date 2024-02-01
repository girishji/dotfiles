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

# fuzzy search cppman
import '../../autoload/popup.vim'
def CppmanFind()
    def GetItems(lst: list<dict<any>>, prompt: string): list<any>
        if prompt->empty()
            var items_dict = [{text: ''}]
            return [items_dict, [items_dict]]
        else
            var parts = prompt->split()
            if parts->len() == 1
                if prompt[prompt->len() - 1] == ' '
                    return [lst, [lst]]
                else
                    var items = system($'cppman -f {parts[0]}')->split("\n")->slice(0, 200) # max 200 items
                    var items_dict = items->mapnew((_, v) => {
                        return {text: v, keyword: v->slice(0, v->stridx(' '))}
                    })
                    return [items_dict, [items_dict]]
                endif
            else # parts count > 1
                var pattern = parts->slice(1)->join()
                return [lst, lst->matchfuzzypos(pattern, {key: "keyword"})]
            endif
        endif
    enddef

    popup.FilterMenuPopup.new().PopupCreate('cppreference', [],
        (res, key) => {
            # exe $":term ++close cppman {res.text}"
            # exe $":!cppman {res.text}"
            exe $":!cppman vector"
        },
        (winid) => {
            win_execute(winid, "syn match FilterMenuDirectorySubtle '\v^\s*\S+\zs.*$'")
            hi def link FilterMenuDirectorySubtle Comment
        },
        GetItems, false, &lines - 6)
enddef
nnoremap <leader>fh <scriptcmd>CppmanFind()<CR>
