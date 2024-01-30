vim9script

# <c-c> instead of <esc> to prevent expansion
# <c-v> to avoid the abbrev expansion in Insert mode (alternatively, <esc>i)
# <c-v> twice to avoid the abbrev expansion in command-line mode
# :ab - to list all abbreviations (a way to debug)
# Trigger abbrev without typing <space> by using <c-]>
# Put a space after abbrev keyword for multiline abbrevs (https://vim.fandom.com/wiki/Multi-line_abbreviations)
# https://vonheikemen.github.io/devlog/tools/using-vim-abbreviations/
# https://github.com/LucHermitte/lh-brackets
# Abbrevs are not recursive (cannot put one inside another) but you can overcome it using :normal cmd
# (https://gurdiga.com/blog/2016/04/08/vim-recursive-iabbrev/)

# align text around # symbol; modify it as needed
cabbr <expr> al  abbr#ExpandCmd('al') ? 's/\v(.*)#(.*)/\=printf("%-16s # %s", submatch(1), submatch(2))/<c-r>=abbr#Eatchar()<cr>' : 'al'
cabbr <expr> v9  abbr#ExpandCmd('v9') ? 'vim9cmd :<c-r>=abbr#Eatchar()<cr>' : 'v9'
cabbr <expr> maek  abbr#ExpandCmd('maek') ? 'make' : 'maek'
# :g search file for pattern and put resulting lines in quickfix list
# <leader>tc or :cw to open the quickfix window
# cabbr <expr> G  abbr#ExpandCmd('G') ? "g//caddexpr $'{expand(\"%\")}:{line(\".\")}:{getline(\".\")}'<c-left><c-left><right><right><c-r>=abbr#Eatchar()<cr>" : G
# alternative to g:// is :il /pattern (searches current file and #include'd files)

iabbr vimhelpfilepostfix vim:tw=78:ts=4:ft=help:norl:modifiable:noreadonly:listchars=tab\:\ \ ,trail\:~:<c-r>=abbr#Eatchar()<cr>

iabbr  --* <esc>d^a<c-r>=repeat('-', getline(line('.') - 1)->trim()->len())<cr><c-r>=abbr#Eatchar()<cr>
inorea dd <C-r>=strftime("%Y-%m-%d")<CR><C-R>=abbr#Eatchar()<CR>
inorea ddd <C-r>=strftime("%Y-%m-%d %H:%M")<CR><C-R>=abbr#Eatchar()<CR>

inorea adn and
inorea teh the
inorea tihs this
inorea thsi this
inorea taht that
inorea thta that
inorea htat that
inorea waht what
inorea whta what
inorea hwat what
inorea rigth right
inorea lenght length
inorea knwo know
inorea kwno know
inorea konw know
inorea clena clean
inorea maek make

inorea todo: TODO:
inorea fixme: FIXME:
inorea xxx: XXX:
inorea task: TASK:

inorea smth something
inorea Smth Something
