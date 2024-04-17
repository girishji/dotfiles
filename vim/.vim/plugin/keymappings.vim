vim9script

# autocomplete with <c-n> and <c-p> when plugins are not available
def WhitespaceOnly(): bool
    # strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return strpart(getline('.'), col('.') - 2, 1) =~ '^\s*$'
enddef
inoremap <expr> <Tab>   WhitespaceOnly() ? "\<tab>" : "\<c-n>"
inoremap <expr> <s-Tab> WhitespaceOnly() ? "\<s-tab>" : "\<c-p>"

# Y mapping, more natural but not vi compatible
map Y y$
# map gm to go to middle of line instead of middle of screen
nnoremap gm gM
# When softwrap happens move by screen line instead of file line
nnoremap j gj
nnoremap k gk
# Jump lines faster (use with H, M, L)
nnoremap <leader>j 5j
vnoremap <leader>j 5j
nnoremap <leader>k 5k
vnoremap <leader>k 5k
# g* selects foo in foobar while * selects <foo>, <> is word boundary. make * behave like g*
# nnoremap * g*
# nnoremap # g#
# Resize window using <ctrl> arrow keys
nnoremap <silent> <C-Up> :resize +2<cr>
nnoremap <silent> <C-Down> :resize -2<cr>
nnoremap <silent> <C-Right> :vertical resize -2<cr>
nnoremap <silent> <C-Left> :vertical resize +2<cr>
# Buffer navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <silent> <leader>h :bprevious<CR>
nnoremap <silent> <leader>l :bnext<CR>
# Replace [[ ]] mappings that get redefined by ftplugin/vim.vim
# autocmd FileType * nnoremap <silent><buffer> [[ :bprevious<CR>
# autocmd FileType * nnoremap <silent><buffer> ]] :bnext<CR>
# Note:  ]" [" may hop comments (:verbose nmap ][)
#   See /opt/homebrew/Cellar/vim/9.0.1550/share/vim/vim90/ftplugin/vim.vim
# quickfix list
nnoremap <silent> [c :cprevious<CR>
nnoremap <silent> ]c :cnext<CR>
nnoremap <silent> [C :cfirst<CR>
nnoremap <silent> ]C :clast<CR>
# location list (buffer local quickfix list)
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>
# file list -> load buffers using :args * :args **/*.js **/*.css
nnoremap <silent> [f :previous<CR>
nnoremap <silent> ]f :next<CR>
nnoremap <silent> [F :first<CR>
nnoremap <silent> ]F :last<CR>

# Map C-/ to do search within visually selected text
# (C-_ produces the same hex code as C-/)
vnoremap <C-_> <Esc>/\%V

# Mute search highlighting.
autocmd VimEnter * nnoremap <silent> <expr> <esc> exists('g:loaded_fFtTplus') ? ':nohls<cr><Plug>(fFtTplus-esc)' : ':nohls<cr><esc>'

# Emacs C-s C-w like solution: hightlight in visual mode and then type * or #
# SID means script local function; cgn to replace text
# https://vonheikemen.github.io/devlog/tools/how-to-survive-without-multiple-cursors-in-vim/
xnoremap * :<c-u> call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<c-u> call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
def VSetSearch(cmdtype: string)
    var temp = getreg('s') # 's' is some register
    norm! gv"sy
    setreg('/', '\V' .. substitute(escape(@s, cmdtype .. '\'), '\n', '\\n', 'g'))
    setreg('s', temp) # restore whatever was in 's'
enddef
# NOTE: Use gp and gP for default purpose
# gp	Just like "p", but leave the cursor just after the new text.
# gP	Just like "P", but leave the cursor just after the new text.
# visually select recent pasted (or typed) text
nnoremap ga `[v`]

# Type %% on Vim’s command-line prompt, it expands to the path of the active buffer
# cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') .. '/' : '%%'

# <leader> mappings
nnoremap <leader>b <cmd>b#<cr>| # alternate buffer
nnoremap <leader>d <cmd>bw<cr>| # :bwipeout to purge, :bdelete still leaves buffer in unlisted state (:ls!)
nnoremap <leader>h <cmd>hide<cr>| # hide window
# nnoremap <leader>u <cmd>unhide<cr><c-w>w| # unhide = one window for each loaded buffer (splits horizontally, not useful)
tnoremap <c-w>h <c-w>:hide<cr>| # hide window (when terminal window is active)
nnoremap <leader>T <cmd>!tree <bar> more<cr>
nnoremap <leader>w <cmd>w<cr>
nnoremap <leader>q <cmd>qa<cr>
nnoremap <leader>Q <cmd>qa!<cr>
nnoremap <leader>n <cmd>only<cr>
nnoremap <leader>- <c-w>s| # horizontal split
# nnoremap <leader>\| <c-w>v| # vertical split
nnoremap <leader>\ <c-w>v| # vertical split
nnoremap <leader>o <c-w>w| # next window in CCW direction
nnoremap <leader>r <cmd>registers<cr>
nnoremap <leader>m <cmd>marks<cr>

# align
vnoremap <leader>A :!column -t<cr>| # align columns
vnoremap <leader>a :'<,'>s/\v(.*)\.(.*)/\=printf("%-16s %s", submatch(1), submatch(2))

# Toggle group
nnoremap <leader>ts :set spell!<CR><Bar>:echo "Spell Check: " .. strpart("OffOn", 3 * &spell, 3)<CR>
nnoremap <silent> <leader>tt <cmd>call text#Toggle()<CR>
nnoremap <expr> <leader>tc empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
nnoremap <expr> <leader>tl empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'

# Vim group
nnoremap <leader>vr :new \| exec "nn <buffer> q :bd!\<cr\>" \| r ! | # redirect shell command, use :il /foo to filter lines
nnoremap <leader>vR :enew \| exec "nn <buffer> q :bd!\<cr\>" \| put = execute('map')<left><left>| # redirect vim cmd, use <leader>fi to filter
# nnoremap <leader>vl <cmd>set buflisted!<cr>
nnoremap <leader>vm <cmd>messages<cr>
nnoremap <leader>vd <cmd>GitDiffThisFile<cr>
nnoremap <leader>ve <cmd>e $MYVIMRC<cr>
nnoremap <leader>vz <cmd>FoldingToggle<cr>
# Following not needed: use 1<c-g> for absolute path, or <c-g> for relative path
# nnoremap <leader>vp <cmd>echo expand('%')<cr>
nnoremap <leader>vi <cmd>ShowImage<cr>

import autoload 'text.vim'

# simple text objects
# -------------------
# i_ i. i: i, i; i| i/ i\ i* i+ i- i# i<tab>
# a_ a. a: a, a; a| a/ a\ a* a+ a- a# a<tab>
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '<tab>' ]
    execute 'xnoremap <silent> i' .. char .. ' <esc><scriptcmd>text.Obj("' .. char .. '", 1)<CR>'
    execute 'xnoremap <silent> a' .. char .. ' <esc><scriptcmd>text.Obj("' .. char .. '", 0)<CR>'
    execute 'onoremap <silent> i' .. char .. ' :normal vi' .. char .. '<CR>'
    execute 'onoremap <silent> a' .. char .. ' :normal va' .. char .. '<CR>'
endfor

nnoremap <silent> <space># <scriptcmd>text.Underline('#')<CR>
nnoremap <silent> <space>* <scriptcmd>text.Underline('*')<CR>
nnoremap <silent> <space>= <scriptcmd>text.Underline('=')<CR>
nnoremap <silent> <space>- <scriptcmd>text.Underline('-')<CR>
nnoremap <silent> <space>^ <scriptcmd>text.Underline('^')<CR>
nnoremap <silent> <space>. <scriptcmd>text.Underline('.')<CR>
