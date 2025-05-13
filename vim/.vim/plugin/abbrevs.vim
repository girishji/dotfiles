" Note:
" Trigger abbrev without typing <space> by using <c-]>
" <c-c> instead of <esc> to prevent expansion
" <c-v> to avoid the abbrev expansion in Insert mode (alternatively, <esc>i)
" <c-v> twice to avoid the abbrev expansion in command-line mode

" 'vim' same as 'vimgrep' (can use Vim style regex)
cabbr <expr> lv abbr#CmdAbbr('lv', $'lv // %<left><left><left><c-r>=abbr#Eatchar()<cr>')

" Modeline
iabbr vim_modeline_help vim:tw=78:ts=4:ft=help:norl:ma:noro:ai:lcs=tab\:\ \ ,trail\:~:<c-r>=abbr#Eatchar()<cr>
iabbr vim_modeline_txt vim:ft=txt:<c-r>=abbr#Eatchar()<cr>
iabbr vim_modeline_markdown vim:tw=80:ts=4:ft=markdown:ai:<c-r>=abbr#Eatchar()<cr>
iabbr vim_modeline_vim " vim: shiftwidth=2 sts=2 expandtab<c-r>=abbr#Eatchar()<cr>

" dashes to match previous line length (there are also key maps in keymappings.vim)
iabbr  --* <esc>d^a<c-r>=repeat('-', getline(line('.') - 1)->trim()->len())<cr><c-r>=abbr#Eatchar()<cr>
iabbr  ==* <esc>d^a<c-r>=repeat('=', getline(line('.') - 1)->trim()->len())<cr><c-r>=abbr#Eatchar()<cr>
iabbr  ~~* <esc>d^a<c-r>=repeat('~', getline(line('.') - 1)->trim()->len())<cr><c-r>=abbr#Eatchar()<cr>

" insert date, and time
" inorea dd <C-r>=strftime("%Y-%m-%d")<CR><C-R>=abbr#Eatchar()<CR>
" inorea ddd <C-r>=strftime("%Y-%m-%d %H:%M")<CR><C-R>=abbr#Eatchar()<CR>

inorea adn and
inorea teh the

" inorea todo: TODO:
inorea fixme: FIXME:<c-r>=abbr#Eatchar()<cr>
inorea xxx: XXX:<c-r>=abbr#Eatchar()<cr>
inorea xxx XXX:<c-r>=abbr#Eatchar()<cr>
inorea note: NOTE:<c-r>=abbr#Eatchar()<cr>
inorea Note: NOTE:<c-r>=abbr#Eatchar()<cr>
