vim9script

export def Eatchar(): string
    var c = nr2char(getchar(0))
    return (c =~ '\s') ? '' : c
enddef
