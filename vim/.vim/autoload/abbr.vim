vim9script

export def Eatchar(): string
    var c = nr2char(getchar(0))
    return (c =~ '\s') ? '' : c
enddef

export def NotCtx(s: string): bool
    if synID(line('.'), col('.') - 1, 1)->synIDattr('name') =~? '\vcomment|string|character|doxygen'
        return true
    endif
    if !s->empty()
        var line = getline(line('.'))
        if line->len() > (s->len() + 1) && line[col('.') - 2 - s->len()] != ' '
            return true
        endif
    endif
    return false
enddef

export def EOL(): bool
    return col('.') == col('$') || getline('.')->strpart(col('.')) =~ '^\s\+$'
enddef

export def CmdAbbr(abbr: string, expn: string): string
    if getcmdtype() == ':'
        var context = getcmdline()->strpart(0, getcmdpos() - 1)
        if context == abbr
            return expn
        endif
    endif
    return abbr
enddef
