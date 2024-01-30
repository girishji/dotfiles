if !has('vim9script') ||  v:version < 900
    finish
endif

vim9script

# credits: https://github.com/habamax/.vim/tree/master

import autoload 'popup.vim'

export def Buffer()
    var buffer_list = getbufinfo({'buflisted': 1})->mapnew((_, v) => {
        return {bufnr: v.bufnr,
                text: (bufname(v.bufnr) ?? $'[{v.bufnr}: No Name]'),
                lastused: v.lastused,
                winid: len(v.windows) > 0 ? v.windows[0] : -1}
    })->sort((i, j) => i.lastused > j.lastused ? -1 : i.lastused == j.lastused ? 0 : 1)
    # Alternate buffer first, current buffer second
    if buffer_list->len() > 1 && buffer_list[0].bufnr == bufnr()
        [buffer_list[0], buffer_list[1]] = [buffer_list[1], buffer_list[0]]
    endif
    popup.FilterMenu("Buffers", buffer_list,
        (res, key) => {
            if key == "\<c-t>"
                exe $":tab sb {res.bufnr}"
            elseif key == "\<c-j>"
                exe $":sb {res.bufnr}"
            elseif key == "\<c-v>"
                exe $":vert sb {res.bufnr}"
            else
                if res.winid != -1
                    win_gotoid(res.winid)
                else
                    exe $":b {res.bufnr}"
                endif
            endif
        },
        (winid) => {
            win_execute(winid, "syn match FilterMenuDirectorySubtle '^.*[\\/]'")
            hi def link FilterMenuDirectorySubtle Comment
        })
enddef

export def MRU()
    var mru = []
    if has("win32")
        # windows is very slow checking if file exists
        # use non-filtered v:oldfiles
        mru = v:oldfiles
    else
        mru = v:oldfiles->filter((_, v) => filereadable(fnamemodify(v, ":p")))
    endif
    popup.FilterMenu("MRU", mru,
        (res, key) => {
            if key == "\<c-t>"
                exe $":tabe {res.text}"
            elseif key == "\<c-j>"
                exe $":split {res.text}"
            elseif key == "\<c-v>"
                exe $":vert split {res.text}"
            else
                exe $":e {res.text}"
            endif
        },
        (winid) => {
            win_execute(winid, "syn match FilterMenuDirectorySubtle '^.*[\\/]'")
            hi def link FilterMenuDirectorySubtle Comment
        })
enddef

export def Template()
    var path = $"{fnamemodify($MYVIMRC, ':p:h')}/templates/"
    var ft = getbufvar(bufnr(), '&filetype')
    var ft_path = path .. ft
    var tmpls = []

    if !empty(ft) && isdirectory(ft_path)
        tmpls = mapnew(readdirex(ft_path, (e) => e.type == 'file'), (_, v) => $"{ft}/{v.name}")
    endif

    if isdirectory(path)
        extend(tmpls, mapnew(readdirex(path, (e) => e.type == 'file'), (_, v) => v.name))
    endif

    popup.FilterMenu("Template",
        tmpls,
        (res, key) => {
            append(line('.'), readfile($"{path}/{res.text}")->mapnew((_, v) => {
                return v->substitute('!!\(.\{-}\)!!', '\=eval(submatch(1))', 'g')
            }))
            if getline('.') =~ '^\s*$'
                del _
            else
                normal! j^
            endif
        })
enddef

export def File(findCmd: string = '', do_sort: bool = false)
    def FindCmd(): string
        if !findCmd->empty()
            return findCmd
        endif
        var sep = has("win32") ? '\' : '/'
        if executable('fd')
            return 'fd -tf --follow'
        else
            # exclude dirs from .config/fd/ignore and .gitignore
            var excludes = []
            var ignore_files = [getenv('HOME') .. '/.config/fd/ignore', '.gitignore']
            for ignore in ignore_files
                if ignore->filereadable()
                    excludes->extend(readfile(ignore)->filter((_, v) => v != '' && v !~ '^#'))
                endif
            endfor
            var exclcmds = []
            for item in excludes
                var idx = item->strridx(sep)
                if idx == item->len() - 1
                    exclcmds->add($'-type d -path */{item}* -prune')
                else
                    exclcmds->add($'-path */{item}/* -prune')
                endif
            endfor
            var cmd = 'find . ' .. (exclcmds->empty() ? '' : exclcmds->join(' -o '))
            return cmd .. ' -o -name *.swp -prune -o -path */.* -prune -o -type f -print -follow'
        endif
    enddef

    popup.FilterMenuAsync("Files", FindCmd()->split(),
        (res, key) => {
            if key == "\<C-j>"
                exe $"split {res.text}"
            elseif key == "\<C-v>"
                exe $"vert split {res.text}"
            elseif key == "\<C-t>"
                exe $"tabe {res.text}"
            else
                exe $":e {res.text}"
            endif
        },
        (winid) => {
            win_execute(winid, "syn match FilterMenuDirectorySubtle '^.*[\\/]'")
            hi def link FilterMenuDirectorySubtle Comment
        },
        do_sort ? (lst: list<any>) => lst->sort() : null_function,
        (lst, prompt) => {
            var matches = lst->matchfuzzypos(prompt, {key: "text", limit: 100})
            if matches[0]->empty()
                return matches
            endif
            # prefer filenames that match over directory names that match
            var filtered = [[], [], []]
            var pat = prompt->split()->get(0)
            for [i, v] in matches[0]->items()
                if v.text->fnamemodify(':t') =~ $'^{pat}'
                    filtered[0]->add(matches[0][i])
                    filtered[1]->add(matches[1][i])
                    filtered[2]->add(matches[2][i])
                endif
            endfor
            for [i, v] in matches[0]->items()
                if v.text->fnamemodify(':t') !~ $'^{pat}'
                    filtered[0]->add(matches[0][i])
                    filtered[1]->add(matches[1][i])
                    filtered[2]->add(matches[2][i])
                endif
            endfor
            return filtered
        })
enddef

export def Keymap()
    var items = execute('map')->split("\n")
    popup.FilterMenu("Keymap", items,
        (res, key) => {
            exe $":echo Keymap"
        })
enddef

export def JumpToWord()
    var word = expand("<cword>")
    if empty(trim(word)) | return | endif
    var lines = []
    for nr in range(1, line('$'))
        var line = getline(nr)
        if line->stridx(word) > -1
            lines->add({text: $"{line} ({nr})", linenr: nr})
        endif
    endfor
    popup.FilterMenu($'Jump to "{word}"', lines,
        (res, key) => {
            exe $":{res.linenr}"
            normal! zz
        },
        (winid) => {
            win_execute(winid, 'syn match FilterMenuLineNr "(\d\+)$"')
            hi def link FilterMenuLineNr Comment
        })
enddef

export def Window()
    var windows = []
    for w_info in getwininfo()
        var tabtext = tabpagenr('$') > 1 ? $"Tab {w_info.tabnr}, " : ""
        var wintext = $"Win {w_info.winnr}"
        var name = empty(bufname(w_info.bufnr)) ? "[No Name]" : bufname(w_info.bufnr)
        var current_sign = w_info.winid == win_getid() ? "*" : " "
        windows->add({text: $"{current_sign}({tabtext}{wintext}): {name} ({w_info.winid})", winid: w_info.winid})
    endfor
    popup.FilterMenu($'Jump window', windows,
        (res, key) => {
            win_gotoid(res.winid)
        },
        (winid) => {
            win_execute(winid, 'syn match FilterMenuRegular "^ (.\{-}):.*(\d\+)$" contains=FilterMenuBraces')
            win_execute(winid, 'syn match FilterMenuCurrent "^\*(.\{-}):.*(\d\+)$" contains=FilterMenuBraces')
            win_execute(winid, 'syn match FilterMenuBraces "(\d\+)$" contained')
            win_execute(winid, 'syn match FilterMenuBraces "^[* ](.\{-}):" contained')
            hi def link FilterMenuBraces Comment
            hi def link FilterMenuCurrent Statement
        })
enddef
