" Key mappings

nnoremap <leader>w <cmd>w<cr>
" nnoremap <leader>w <cmd>update<cr> " BufWrite (not posted) is needed by plugins
nnoremap <leader>q <cmd>qa<cr>
nnoremap <leader>Q <cmd>qa!<cr>

" <c-l> deletes for beginning of line in insert mode
" (<c-u> will delete to first indented col)
inoremap <c-l> <c-o>d0<c-o>x

" Y mapping, more natural but not vi compatible
map Y y$

" map gm to go to middle of line instead of middle of screen
nnoremap gm gM

" For autocomplete
inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" When softwrap happens move by screen line instead of file line
nnoremap <silent> j gj
nnoremap <silent> k gk

" Jump lines faster (use with H, M, L)
nnoremap <leader>j 8j
vnoremap <leader>j 8j
nnoremap <leader>k 8k
vnoremap <leader>k 8k

" alternative to 'packadd nohlsearch'. use <cmd> to avoid triggering CmdlineEnter.
nnoremap <silent> <esc> <cmd>nohls<cr><esc>

" Word search
nnoremap <leader>/ /\<
nnoremap <leader>? ?\<

" Buffer navigation
nnoremap <silent> <leader>[ :bprevious<CR>
nnoremap <silent> <leader>] :bnext<CR>
" nnoremap <silent> [<space> :bprevious<CR>
" nnoremap <silent> ]<space> :bnext<CR>
" nnoremap <leader><pagedown> <cmd>bprevious<cr>
" nnoremap <leader><pageup> <cmd>bnext<cr>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <leader>b <cmd>b#<cr>
nnoremap <leader>d <cmd>bw<cr>

" quickfix list
if !&diff  " vimdiff uses [c and ]c
    nnoremap <silent> [c :cprevious<CR>
    nnoremap <silent> ]c :cnext<CR>
    " nnoremap <silent> [C :cfirst<CR>
    " nnoremap <silent> ]C :clast<CR>
    nnoremap <silent> [C :colder<CR>
    nnoremap <silent> ]C :cnewer<CR>
endif

" location list (buffer local quickfix list)
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>

" arg (file) list -> load buffers using :args * :args **/*.js **/*.css
" nnoremap <silent> [f :previous<CR>
" nnoremap <silent> ]f :next<CR>
" nnoremap <silent> [F :first<CR>
" nnoremap <silent> ]F :last<CR>
nnoremap <silent> [a :previous<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> [A :first<CR>
nnoremap <silent> ]A :last<CR>

" Map C-/ to do search within visually selected text
" (C-_ produces the same hex code as C-/)
vnoremap <C-_> <Esc>/\%V

" Emacs C-s C-w like solution: hightlight in visual mode and then type * or #
" `cgn` to replace text
" https://vonheikemen.github.io/devlog/tools/how-to-survive-without-multiple-cursors-in-vim/
xnoremap * :<c-u> call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<c-u> call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
" SID means script local function
func s:VSetSearch(cmdtype)
  let temp = getreg('s') " 's' is some register
  norm! gv"sy
  call setreg('/', '\V' .. substitute(escape(@s, a:cmdtype .. '\'), '\n', '\\n', 'g'))
  call setreg('s', temp) " restore whatever was in 's'
endfunc

" visually select recent pasted (or typed) text
"   remember `] takes you to end of pasted buffer, or use 'gp' to paste
nnoremap gs `[v`]

" nnoremap <leader>t <cmd>!tree <bar> more<cr>
" nnoremap <leader>t <cmd>term<cr>

" Tabs
" NOTE: For tabnext/tabprev use Cmd+top_right/left keys (mapped to
"   ctrl+pgdn/pgup)
nnoremap <leader>tt <cmd>tabnew %<cr>
nnoremap <leader>tn <cmd>tabnew %<cr>
nnoremap <leader>te <cmd>tabe %<cr>
nnoremap <leader>tc <cmd>tabclose<cr>
nnoremap <leader>D <cmd>tabclose<cr>
nnoremap <leader>T <cmd>tab term<CR>
nnoremap <leader>tT <cmd>tab term<CR>

" Windows
"   (<C-W> is a key on qmk keyboard)
" horizontal split
nnoremap <leader>- <c-w>s
" vertical split
nnoremap <leader>\ <c-w>v
nnoremap <silent> <C-Up> :resize +2<cr>
nnoremap <silent> <C-Down> :resize -2<cr>
nnoremap <silent> <C-Right> :vertical resize -2<cr>
nnoremap <silent> <C-Left> :vertical resize +2<cr>
" hide window (when terminal window is active)
tnoremap <c-w>H <c-w>:hide<cr>
" hide window
nnoremap <c-w>H <cmd>hide<cr>

" Align
vnoremap <leader>A :!column -t<cr>| " align columns
vnoremap <leader>a :s/\v(.*)=(.*)/\=printf("%-16s %s", submatch(1), submatch(2))

" Toggle group
nnoremap <leader>vs :set spell!<CR><Bar>:echo "Spell Check: " .. strpart("OffOn", 3 * &spell, 3)<CR>
" nnoremap <expr> <leader>vc empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
" nnoremap <expr> <leader>vl empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'

" redirect shell command, use :il /foo to filter lines
nnoremap <leader>vR :new \| exec "nn <buffer> q :bd!\<cr\>" \| r !
" redirect vim cmd, use <leader>fi to filter
nnoremap <leader>vr :enew \| exec "nn <buffer> q :bd!\<cr\>" \| put = execute('')<left><left>

nnoremap <leader>vm <cmd>messages<cr>
nnoremap <leader>ve <cmd>e $MYVIMRC<cr>
nnoremap <leader>vz <cmd>e ~/.zsh.common<cr>
nnoremap <leader>vg <cmd>e ~/.gvimrc<cr>
" open netrw file browser
nnoremap <leader>vn <cmd>35Lex<cr>
" tags
nnoremap <leader>vt <cmd>!ctags -R<cr>

" Make <C-PageUp/Down> switch tabs when tab has a terminal open
func s:SwitchTab(dir)
    if &buftype == 'terminal'
        exec "normal! \<C-\>\<C-n>"
        exec (a:dir == 'up' ? "tabNext" : "tabnext")
    else
        exec (a:dir == 'up' ? "tabNext" : "tabnext")
    endif
endfunc
tnoremap <silent> <C-PageUp> <scriptcmd>SwitchTab('up')<cr>
tnoremap <silent> <C-PageDown> <scriptcmd>SwitchTab('down')<cr>

" " highlight groups ([-1] forces empty string as return value of setqflist())
" nnoremap <leader>fh :<c-r>=setqflist([], ' ', #{title: 'highlight', items: execute("hi")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
nnoremap <leader>fk :<c-r>=setqflist([], ' ', #{title: 'keymap', items: execute("verbose map")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
" nnoremap <leader>fm :<c-r>=setqflist([], ' ', #{title: 'marks', items: execute("marks")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
" nnoremap <leader>fr :<c-r>=setqflist([], ' ', #{title: 'registers', items: execute("registers")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
" nnoremap <leader>fq <cmd>chistory<cr>

" vim: shiftwidth=2 sts=2 expandtab
