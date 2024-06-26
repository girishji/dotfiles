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
cabbr <expr> al  abbr#CmdAbbr('al', 's/\v(.*)#(.*)/\=printf("%-16s # %s", submatch(1), submatch(2))/<c-r>=abbr#Eatchar()<cr>')

# 'vim9cmd' same as 'vim9'
cabbr <expr> v9  abbr#CmdAbbr('v9', 'vim9 <c-r>=abbr#Eatchar()<cr>')
cabbr <expr> maek  abbr#CmdAbbr('maek', 'make')

# :g search file for pattern and put resulting lines in quickfix list
# <leader>tc or :cw to open the quickfix window
#   alternative to g:// is :il /pattern (searches current file and #include'd files)
# cabbr <expr> gg  abbr#CmdAbbr('gg') ? "g//caddexpr $'{expand(\"%\")}:{line(\".\")}:{getline(\".\")}'<c-left><c-left><right><right><c-r>=abbr#Eatchar()<cr>" : gg

# cabbr <expr> zz  abbr#CmdAbbr('zz') ? 'e ~/.zsh/.zshrc<cr>' : 'zz'
# cabbr <expr> ze  abbr#CmdAbbr('ze') ? 'e ~/.zshenv<cr>' : 'ze'
# cabbr <expr> gr  abbr#CmdAbbr('gr') ? 'silent grep!' : 'gr'
# cabbr <expr> vg  abbr#CmdAbbr('vg') ? 'vim //j' : 'vg'

iabbr vimhelpftpostfix vim:tw=78:ts=4:ft=help:norl:ma:noro:ai:lcs=tab\:\ \ ,trail\:~:<c-r>=abbr#Eatchar()<cr>
iabbr txtftpostfix vim:ft=txt:<c-r>=abbr#Eatchar()<cr>

# dashes to match previous line length (there are also key maps in keymappings.vim)
iabbr  --* <esc>d^a<c-r>=repeat('-', getline(line('.') - 1)->trim()->len())<cr><c-r>=abbr#Eatchar()<cr>
iabbr  ==* <esc>d^a<c-r>=repeat('=', getline(line('.') - 1)->trim()->len())<cr><c-r>=abbr#Eatchar()<cr>
iabbr  ~~* <esc>d^a<c-r>=repeat('~', getline(line('.') - 1)->trim()->len())<cr><c-r>=abbr#Eatchar()<cr>

# insert date, and time
# inorea dd <C-r>=strftime("%Y-%m-%d")<CR><C-R>=abbr#Eatchar()<CR>
# inorea ddd <C-r>=strftime("%Y-%m-%d %H:%M")<CR><C-R>=abbr#Eatchar()<CR>

inorea adn and
inorea teh the

# inorea todo: TODO:
inorea fixme: FIXME:
inorea xxx: XXX:
# inorea task: TASK:
