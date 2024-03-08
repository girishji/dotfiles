vim9script

iab <buffer><expr> if      abbr#NotCtx('if') ? 'if' : 'if  then<c-o>oend<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> while   abbr#NotCtx('while') ? 'while' : 'while  do<c-o>oend<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> for     abbr#NotCtx('for' ) ? 'for' : 'for a, b in pairs() do<c-o>oend<esc>k_ella<c-r>=abbr#Eatchar()<cr>'
iab <buffer> forr          for i = a, #a do<c-o>oend<esc>k_ella<c-r>=abbr#Eatchar()<cr>
iab <buffer> function      function ()<c-o>oend<esc>k_2wa<c-r>=abbr#Eatchar()<cr>

# popup menu

if exists('g:loaded_scope')
    import autoload 'scope/fuzzy.vim'

    def Things()
        var things = []
        for nr in range(1, line('$'))
            var line = getline(nr)
            if line =~ '\v(^|\s)function' || line =~ '\v^\k+\s+\='
                things->add({text: $"{line} ({nr})", linenr: nr})
            endif
        endfor
        things->filter((_, v) => v.text !~ '\v^\s*--')
        fuzzy.FilterMenu.new("Lua Things", things,
            (res, key) => {
                exe $":{res.linenr}"
                normal! zz
            },
            (winid) => {
                win_execute(winid, $"syn match FilterMenuLineNr '(\\d\\+)$'")
                hi def link FilterMenuLineNr Comment
            })
    enddef

    nnoremap <buffer> <space>/ <scriptcmd>Things()<CR>
endif
