if !has('vim9script') ||  v:version < 900
    finish
endif

vim9script

import autoload 'popup.vim'

def GetItems(lst: list<dict<any>>, prompt: string): list<any>
    def PrioritizeFilename(matches: list<any>): list<any>
        # prefer filenames that match over directory names that match
        var filtered = [[], [], []]
        var pat = prompt->trim()
        for Filterfn in [(x, y) => x =~ y, (x, y) => x !~ y]
            for [i, v] in matches[0]->items()
                if Filterfn(v.text->fnamemodify(':t'), $'^{pat}')
                    filtered[0]->add(matches[0][i])
                    filtered[1]->add(matches[1][i])
                    filtered[2]->add(matches[2][i])
                endif
            endfor
        endfor
        return filtered
    enddef
    if prompt->empty()
        return [lst, [lst]]
    else
        var pat = prompt->trim()
        # var matches = lst->matchfuzzypos(pat, {key: "text", limit: 1000})
        var matches = lst->matchfuzzypos(pat, {key: "text"})
        if matches[0]->empty() || pat =~ '\s'
            return [lst, matches]
        else
            return [lst, PrioritizeFilename(matches)]
        endif
    endif
enddef

# fuzzy find files
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
        GetItems)
enddef

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
        },
        GetItems)
enddef

export def Keymap()
    var items = execute('map')->split("\n")
    popup.FilterMenu("Keymap", items,
        (res, key) => {
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
