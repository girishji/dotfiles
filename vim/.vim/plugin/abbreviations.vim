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
# cabbr <expr> al  abbr#CmdAbbr('al', 's/\v(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/\=printf("%-20 %-10s %-10s %-10s %s", submatch(1), submatch(2), submatch(3), submatch(4), submatch(5))/<c-r>=abbr#Eatchar()<cr>')

# 'vim9cmd' same as 'vim9'
cabbr <expr> v9  abbr#CmdAbbr('v9', 'vim9 <c-r>=abbr#Eatchar()<cr>')
cabbr <expr> maek  abbr#CmdAbbr('maek', 'make')

# vimgrep opens quickfix immediately, while 'grep' needs an additional <CR>
# 'vim' same as 'vimgrep' (can use Vim style regex)
cabbr <expr> v  abbr#CmdAbbr('v', $'vim /\v/gj **<left><left><left><left><left><left><c-r>=abbr#Eatchar()<cr>')
cabbr <expr> vim  abbr#CmdAbbr('vim', $'vim /\v/gj **<left><left><left><left><left><left><c-r>=abbr#Eatchar()<cr>')
cabbr <expr> vw  abbr#CmdAbbr('vw', $'vim /\v{expand("<cword>")}/gj **<left><left><left><left><left><left><c-r>=abbr#Eatchar()<cr>')
cabbr <expr> vimw  abbr#CmdAbbr('vimw', $'vim /\v{expand("<cword>")}/gj **<left><left><left><left><left><left><c-r>=abbr#Eatchar()<cr>')
# grep: 1) to exclude dirs use ':gr "foo" **/*~*/bar/*' (dot dirs are automatically excluded)
#   2) -E (in grepprg) is extended grep, which is like '\v' in Vim. Escapes +, |, ., and ?. ex. grep -E "mp4|avi"
#   3) gr[ep]! will not automatically visit first file
cabbr <expr> gr  abbr#CmdAbbr('gr', 'gr! ""<left><c-r>=abbr#Eatchar()<cr>')

# :g search file for pattern and put resulting lines in quickfix list
# <leader>tc or :cw to open the quickfix window
#   alternative to g:// is :il /pattern (searches current file and #include'd files)
cabbr <expr> gg  abbr#CmdAbbr('gg', "g//caddexpr $'{expand(\"%\")}:{line(\".\")}:{getline(\".\")}'<c-left><c-left><right><right><c-r>=abbr#Eatchar()<cr>")

# cabbr <expr> zz  abbr#CmdAbbr('zz') ? 'e ~/.zsh/.zshrc<cr>' : 'zz'
# cabbr <expr> ze  abbr#CmdAbbr('ze') ? 'e ~/.zshenv<cr>' : 'ze'
# cabbr <expr> gr  abbr#CmdAbbr('gr') ? 'silent grep!' : 'gr'
# cabbr <expr> vg  abbr#CmdAbbr('vg') ? 'vim //j' : 'vg'

iabbr vim_help_modeline vim:tw=78:ts=4:ft=help:norl:ma:noro:ai:lcs=tab\:\ \ ,trail\:~:<c-r>=abbr#Eatchar()<cr>
iabbr vim_txt_modeline vim:ft=txt:<c-r>=abbr#Eatchar()<cr>
iabbr vim_markdown_modeline vim:tw=80:ts=4:ft=markdown:ai:<c-r>=abbr#Eatchar()<cr>
iabbr vim_modeline vim:ts=4:sts=4:et:ai:<c-r>=abbr#Eatchar()<cr>

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
# inorea note: NOTE:
# inorea task: TASK:
