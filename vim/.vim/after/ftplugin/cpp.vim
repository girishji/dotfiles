vim9script

iabbr <buffer> for_each_   for_each(v.begin(),v.end(),[](int& x){x=;});<esc>-fi;<c-r>=abbr#Eatchar()<cr>

setl dictionary=$HOME/.vim/data/cpp.dict

# setl path-=/usr/include

if exists(":LspDocumentSymbol") == 2
    nnoremap <buffer> <leader>/ <cmd>LspDocumentSymbol<CR>
endif

if exists("g:loaded_vimcomplete")
    g:VimCompleteOptionsSet({
        lsp: { enable: true, maxCount: 50, priority: 11 },
    })
endif

# cppman to view cppreference.com documentation
# command -complete=custom,ListCppKeywords -nargs=1 Cppman :term ++close cppman <args>
# def ListCppKeywords(ArgLead: string, CmdLine: string, CursorPos: number): string
#     return system($'cppman -f {ArgLead}')
# enddef

# nnoremap <buffer> <leader>H :Cppman<space>
# cabbr <expr> hh  abbr#ExpandCmd('hh') ? 'Cppman <c-r>=abbr#Eatchar()<cr>' : 'hh'

# fuzzy search cppman
# runtime! after/ftplugin/man.vim
# if exists('g:loaded_scope')
#     import 'fuzzyscope.vim' as fuzzy
# def CppmanFind()
#     def GetItems(lst: list<dict<any>>, prompt: string): list<any>
#         if prompt->empty()
#             var items_dict = [{text: ''}]
#             return [items_dict, [items_dict]]
#         else
#             var parts = prompt->split()
#             if parts->len() == 1
#                 if prompt[prompt->len() - 1] == ' '
#                     return [lst, [lst]]
#                 else
#                     var items = system($'cppman -f {parts[0]}')->split("\n")->slice(0, 200) # max 200 items
#                     var items_dict = items->mapnew((_, v) => {
#                         return {text: v, keyword: v->slice(0, v->stridx(' '))}
#                     })
#                     return [items_dict, [items_dict]]
#                 endif
#             else # parts count > 1
#                 var pattern = parts->slice(1)->join()
#                 return [lst, lst->matchfuzzypos(pattern, {key: "keyword"})]
#             endif
#         endif
#     enddef

#     fuzzy.FilterMenuPopup.new().PopupCreate('cppreference', [],
#         (res, key) => {
#             exe $":Man {res.keyword}"
#         },
#         (winid) => {
#             win_execute(winid, 'syn match FilterMenuDirectorySubtle " - .*$"')
#             hi def link FilterMenuDirectorySubtle Comment
#         },
#         GetItems, false, &lines - 6, (&columns * 0.75)->float2nr())
# enddef
# nnoremap <buffer> <leader>fh <scriptcmd>CppmanFind()<CR>
