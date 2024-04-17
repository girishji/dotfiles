iab <buffer> --- ------------------------------------------------------------------------------<c-r>=abbr#Eatchar()<cr>
iab <buffer> === ==============================================================================<c-r>=abbr#Eatchar()<cr>

# Yank the visual selection before using followng abbrevs, to get selection into register 0 or "
# '"' is the default register (:h v:register), when no register is 'active' or specified.
# Registers are also set, so you can use @u, @b, @i.
cabbr <expr> ぬ 's/<c-r>0/ぬ&ぬ<c-r>=abbr#Eatchar()<cr>'
setreg('u', ":s/\<c-r>0/ぬ&ぬ\<cr>")
cabbr <expr> ぼ 's/<c-r>0/ぼ&ぼ<c-r>=abbr#Eatchar()<cr>'
setreg('b', ":s/\<c-r>0/ぼ&ぼ\<cr>")
cabbr <expr> ち 's/<c-r>0/ち&ち<c-r>=abbr#Eatchar()<cr>'
setreg('i', ":s/\<c-r>0/ち&ち\<cr>")
