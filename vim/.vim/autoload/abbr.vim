vim9script

export def Eatchar(): string
    var c = nr2char(getchar(0))
    # return (c =~ '\m\s\<bar>/') ? '' : c  # eat space and '/'
    return (c =~ '\s\|/') ? '' : c  # eat space and '/'
enddef

export def NotCtx(s: string): bool
    if synID(line('.'), col('.') - 1, 1)->synIDattr('name') =~? '\vcomment|string|character|doxygen'
        return true
    elseif !s->empty() # inside a comment, but check if there is a space behind 's'
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
        var ctx = getcmdline()->strpart(0, getcmdpos() - 1)
        # :h :range and :h :range-pattern (can be very complicated)
        # \?, \=, \{0,1} do the same thing
        if ctx =~ '^\(''<,''>\|''\a,''\a\|%\|\d\+\|\d\+,\d\+\)\=' .. abbr
            return expn
        endif
    endif
    return abbr
enddef

# Can have iabs that inserted #replaceme# at various places and have a
# keymap that jumped to the next #replaceme# and did ciW.
# Can set a buffer variable that abbrev is expanded, and map <tab> to hop to
# specific locations.
