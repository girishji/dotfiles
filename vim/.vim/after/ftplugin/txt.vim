if exists("b:did_ftplugin")
    finish
endif

let b:undo_ftplugin = "setl ts< fo< tw< cole< cocu< cms< com< flp< lcs< ai<"

" autoindent is needed to wrap list lines (if #lines > 2)
setlocal formatoptions+=tcroql ts=4 textwidth=80 lcs=tab:\ \ ,trail:~ comments= cms= autoindent

if has("conceal")
    setlocal cole=2 cocu=nc
endif

iab <buffer> --- ------------------------------------------------------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer> === ==============================================================================<c-r>=abbr#Eatchar()<cr>

setlocal formatlistpat=^\\s*                     " Optional leading whitespace
setlocal formatlistpat+=[                        " Start character class
setlocal formatlistpat+=\\[({]\\?                " |  Optionally match opening punctuation
setlocal formatlistpat+=\\(                      " |  Start group
setlocal formatlistpat+=[0-9]\\+                 " |  |  Numbers
setlocal formatlistpat+=\\\|                     " |  |  or
setlocal formatlistpat+=[a-zA-Z]\\+              " |  |  Letters
setlocal formatlistpat+=\\)                      " |  End group
setlocal formatlistpat+=[\\]:.)}                 " |  Closing punctuation
setlocal formatlistpat+=]                        " End character class
setlocal formatlistpat+=\\s\\+                   " One or more spaces
setlocal formatlistpat+=\\\|                     " or
setlocal formatlistpat+=^\\s*[-–+o*•]\\s\\+      " Bullet points
