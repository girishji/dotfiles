vim9script

# https://github.com/habamax/.vim/blob/master/after/ftplugin/vim.vim

setl textwidth=80
setl keywordprg=:help
setl sw=4 ts=8 sts=4 et

iab <buffer> #--- #------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer><expr> augroup abbr#NotCtx('augroup') ? 'augroup' : 'augroup  \| autocmd!<cr>augroup END<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> def     abbr#NotCtx('def') ? 'def' : 'def <c-o>oenddef<esc>k_ffla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> def!    abbr#NotCtx('def!') ? 'def!' : 'def! <c-o>oenddef<esc>k_ffla<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> if      abbr#NotCtx('if') ? 'if' : 'if <c-o>oendif<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> while   abbr#NotCtx('while') ? 'while' : 'while <c-o>oendwhile<esc>k_ela<c-r>=abbr#Eatchar()<cr>'
iab <buffer><expr> for     abbr#NotCtx('for' ) ? 'for' : 'for <c-o>oendfor<esc>k_ela<c-r>=abbr#Eatchar()<cr>'

# Convince vim that 'def' is a macro like C's #define
setlocal define=^\\s*def
b:undo_ftplugin ..= ' | setlocal define<'

# setl softtabstop=4 shiftwidth=4 expandtab
# exe 'setlocal listchars=tab:\│\ ,multispace:\│' .. repeat('\ ', &sw - 1) .. ',trail:~'

if exists('g:loaded_scope')
    import autoload 'scope/popup.vim'

    def Things()
        var things = []
        for nr in range(1, line('$'))
            var line = getline(nr)
            if line =~ '\(^\|\s\)def \k\+('
                    || line =~ '\(^\|\s\)class \k\+'
                    || line =~ '\(^\|\s\)fu\%[nction]!\?\s\+\([sgl]:\)\?\k\+('
                    || line =~ '^\s*com\%[mand]!\?\s\+\S\+'
                    || line =~ '^\s*aug\%[roup]\s\+\S\+' && line !~ '\c^\s*aug\%[roup] end\s*$'
                if line =~ '^\s*com\%[mand]!\?\s\+\S\+'
                    line = line->substitute(' -\(range\|count\|nargs\)\(=.\)\?', '', 'g')
                    line = line->substitute(' -\(bang\|buffer\)', '', '')
                    line = line->substitute(' -complete=\S\+', '', '')
                    line = line->substitute('^\s*com\%[mand]!\?\s\+\S\+\zs.*', '', '')
                    line = line->substitute('^\s*com\%[mand]!\?\s\+', '', '')
                endif
                things->add({text: $"{line} ({nr})", linenr: nr})
            endif
        endfor
        popup.FilterMenu.new("Vim Things", things,
            (res, key) => {
                exe $":{res.linenr}"
                normal! zz
            },
            (winid, _) => {
                win_execute(winid, $"syn match FilterMenuLineNr '(\\d\\+)$'")
                hi def link FilterMenuLineNr Comment
            })
    enddef
    nnoremap <buffer> <space>/ <scriptcmd>Things()<CR>
elseif exists('g:loaded_vimsuggest')
    # import autoload 'vimsuggest/addons/addons.vim'
    # command! -nargs=* -complete=customlist,Complete VSArtifacts addons.DoArtifactsAction(<f-args>)
    # nnoremap <buffer> <leader>/ :VSArtifacts<space>
    # def Complete(A: string, L: string, C: number): list<any>
    #     var patterns = [
    #         '\(^\|\s\)def\s\+\zs\k\+\ze(',
    #         '\(^\|\s\)fu\%[nction]!\?\s\+\([sgl]:\)\?\zs\k\+\ze(',
    #         '^\s*com\%[mand]!\?\s\+\zs\S\+\ze'
    #     ]
    #     return addons.ArtifactsComplete(A, L, C, patterns)
    # enddef
    # :defcompile # Otherwise compile errors within Complete() show up only upon pressing <tab>
    nnoremap <buffer> <leader>/ :VSGlobal \v^\s*(def\|com%[mand])!?.*
else
    def Definitions(): list<any>
        var items = []
        var patterns = [
            '\(^\|\s\)def\s\+\zs\k\+\ze(',
            '\(^\|\s\)fu\%[nction]!\?\s\+\([sgl]:\)\?\zs\k\+\ze(',
            '^\s*com\%[mand]!\?\s\+\zs\S\+\ze'
        ]
        for nr in range(1, line('$'))
            var line = getline(nr)
            for pat in patterns
                var name = line->matchstr(pat)
                if name != null_string
                    items->add({text: name, lnum: nr})
                    break
                endif
            endfor
        endfor
        return items->copy()->filter((_, v) => v !~ '^\s*#')
    enddef
    command -buffer -nargs=* -complete=customlist,Completor VimGoTo DoCommand(<f-args>)
    nnoremap <buffer> <leader>/ :VimGoTo<space>
    def DoCommand(arg: string = null_string)
        var items = (arg == null_string) ? Definitions() : Definitions()->matchfuzzy(arg, {matchseq: 1, key: 'text'})
        if !items->empty()
            exe $":{items[0].lnum}"
            normal! zz
        endif
    enddef
    def Completor(arg: string, cmdline: string, cursorpos: number): list<any>
        var items = (arg == null_string) ? Definitions() : Definitions()->matchfuzzy(arg, {matchseq: 1, key: 'text'})
        return items->mapnew((_, v) => v.text)
    enddef
endif
