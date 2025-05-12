vim9script

# General
# nnoremap <leader>w <cmd>w<cr>
nnoremap <leader>w <cmd>update<cr>
nnoremap <leader>q <cmd>qa<cr>
nnoremap <leader>Q <cmd>qa!<cr>
nnoremap <leader>r <cmd>registers<cr>
nnoremap <leader>m <cmd>marks<cr>
# Y mapping, more natural but not vi compatible
map Y y$
# map gm to go to middle of line instead of middle of screen
nnoremap gm gM
# When softwrap happens move by screen line instead of file line
nnoremap j gj
nnoremap k gk
# Jump lines faster (use with H, M, L)
nnoremap <leader>j 8j
vnoremap <leader>j 8j
nnoremap <leader>k 8k
vnoremap <leader>k 8k
# alternative to 'packadd nohlsearch'. use <cmd> to avoid triggering CmdlineEnter.
nnoremap <silent> <esc> <cmd>nohls<cr><esc>

# Buffer navigation
# nnoremap <silent> <leader>[ :bprevious<CR>
# nnoremap <silent> <leader>] :bnext<CR>
# nnoremap <silent> [<space> :bprevious<CR>
# nnoremap <silent> ]<space> :bnext<CR>
nnoremap <leader><pagedown> <cmd>bprevious<cr>
nnoremap <leader><pageup> <cmd>bnext<cr>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <leader>b <cmd>b#<cr>| # alternate buffer
nnoremap <leader>d <cmd>bw<cr>| # :bwipeout to purge, :bdelete still leaves buffer in unlisted state (:ls!)


# quickfix list
if !&diff  # vimdiff uses [c and ]c
    nnoremap <silent> [c :cprevious<CR>
    nnoremap <silent> ]c :cnext<CR>
    # nnoremap <silent> [C :cfirst<CR>
    # nnoremap <silent> ]C :clast<CR>
    nnoremap <silent> [C :colder<CR>
    nnoremap <silent> ]C :cnewer<CR>
endif

# location list (buffer local quickfix list)
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>

# arg (file) list -> load buffers using :args * :args **/*.js **/*.css
# nnoremap <silent> [f :previous<CR>
# nnoremap <silent> ]f :next<CR>
# nnoremap <silent> [F :first<CR>
# nnoremap <silent> ]F :last<CR>
nnoremap <silent> [a :previous<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> [A :first<CR>
nnoremap <silent> ]A :last<CR>

# Map C-/ to do search within visually selected text
# (C-_ produces the same hex code as C-/)
vnoremap <C-_> <Esc>/\%V

# Emacs C-s C-w like solution: hightlight in visual mode and then type * or #
# `cgn` to replace text
# https://vonheikemen.github.io/devlog/tools/how-to-survive-without-multiple-cursors-in-vim/
xnoremap * :<c-u> call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<c-u> call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
# SID means script local function; 'call' is optional in vim9script.
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
#   remember `] takes you to end of pasted buffer, or use 'gp' to paste
nnoremap gs `[v`]

# nnoremap <leader>t <cmd>!tree <bar> more<cr>
# nnoremap <leader>t <cmd>term<cr>

# Tabs
# NOTE: For tabnext/tabprev use Cmd+top_right/left keys (mapped to
#   ctrl+pgdn/pgup)
# nnoremap <c-w><pagedown> <cmd>tabprev<cr>
# nnoremap <c-w><pageup> <cmd>tabnext<cr>
nnoremap <silent> <leader>[ <cmd>tabprev<CR>
nnoremap <silent> <leader>] <cmd>tabnext<CR>
# nnoremap <silent> [<space> :bprevious<CR>
# nnoremap <silent> ]<space> :bnext<CR>
nnoremap <leader>tt <cmd>tabnew %<cr>
nnoremap <leader>tn <cmd>tabnew %<cr>
nnoremap <leader>te <cmd>tabe %<cr>
nnoremap <leader>tc <cmd>tabclose<cr>
nnoremap <leader>T <cmd>tab term<CR>
nnoremap <leader>tT <cmd>tab term<CR>

# Windows
#   (<C-W> is a key on qmk keyboard)
nnoremap <leader>- <c-w>s| # horizontal split
# nnoremap <leader>\| <c-w>v| # vertical split
nnoremap <leader>\ <c-w>v| # vertical split
nnoremap <silent> <C-Up> :resize +2<cr>
nnoremap <silent> <C-Down> :resize -2<cr>
nnoremap <silent> <C-Right> :vertical resize -2<cr>
nnoremap <silent> <C-Left> :vertical resize +2<cr>
tnoremap <c-w>H <c-w>:hide<cr>| # hide window (when terminal window is active)
nnoremap <c-w>H <cmd>hide<cr>| # hide window

# Align
vnoremap <leader>A :!column -t<cr>| # align columns
vnoremap <leader>a :s/\v(.*)=(.*)/\=printf("%-16s %s", submatch(1), submatch(2))

# Toggle group
nnoremap <leader>vs :set spell!<CR><Bar>:echo "Spell Check: " .. strpart("OffOn", 3 * &spell, 3)<CR>
# nnoremap <silent> <leader>vt <cmd>call text#Toggle()<CR>
# nnoremap <expr> <leader>vc empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
# nnoremap <expr> <leader>vl empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'

# Vim group
nnoremap <leader>vR :new \| exec "nn <buffer> q :bd!\<cr\>" \| r ! | # redirect shell command, use :il /foo to filter lines
nnoremap <leader>vr :enew \| exec "nn <buffer> q :bd!\<cr\>" \| put = execute('')<left><left>| # redirect vim cmd, use <leader>fi to filter
# nnoremap <leader>vl <cmd>set buflisted!<cr>
nnoremap <leader>vm <cmd>messages<cr>
# nnoremap <leader>vd <cmd>GitDiffThisFile<cr>
nnoremap <leader>ve <cmd>e $MYVIMRC<cr>
nnoremap <leader>vz <cmd>e ~/.zsh.common<cr>
nnoremap <leader>vg <cmd>e ~/.gvimrc<cr>
# nnoremap <leader>vz <cmd>FoldingToggle<cr>
# Following not needed: use 1<c-g> for absolute path, or <c-g> for relative path
# nnoremap <leader>vp <cmd>echo expand('%')<cr>
nnoremap <leader>vi <cmd>ShowImage<cr>
# open netrw file browser
nnoremap <leader>vf <cmd>35Lex<cr>
nnoremap <leader>vn <cmd>35Lex<cr>

# ----------------------------------------
# Make <C-PageUp/Down> work in tab with terminal
# ----------------------------------------
def SwitchTab(dir: string)
    if &buftype == 'terminal'
        :exec "normal! \<C-\>\<C-n>"
        :exec (dir == 'up' ? "tabNext" : "tabnext")
    else
        :exec (dir == 'up' ? "tabNext" : "tabnext")
    endif
enddef
tnoremap <silent> <C-PageUp> <scriptcmd>SwitchTab('up')<cr>
tnoremap <silent> <C-PageDown> <scriptcmd>SwitchTab('down')<cr>

# # ----------------------------------------
# import '../autoload/text.vim'

# # surround ', ", and `
# vnoremap <silent> <leader>' <scriptcmd>text.Surround('''')<cr>
# vnoremap <silent> <leader>" <scriptcmd>text.Surround('"')<cr>
# vnoremap <silent> <leader>` <scriptcmd>text.Surround('`')<cr>
# nnoremap <silent> <leader>' <scriptcmd>text.Surround('''')<cr>
# nnoremap <silent> <leader>" <scriptcmd>text.Surround('"')<cr>
# nnoremap <silent> <leader>` <scriptcmd>text.Surround('`')<cr>

# # simple text objects
# # -------------------
# # i_ i. i: i, i; i| i/ i\ i* i+ i- i# i<tab>
# # a_ a. a: a, a; a| a/ a\ a* a+ a- a# a<tab>
# for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '<tab>' ]
#     execute 'xnoremap <silent> i' .. char .. ' <esc><scriptcmd>text.Obj("' .. char .. '", 1)<CR>'
#     execute 'xnoremap <silent> a' .. char .. ' <esc><scriptcmd>text.Obj("' .. char .. '", 0)<CR>'
#     execute 'onoremap <silent> i' .. char .. ' :normal vi' .. char .. '<CR>'
#     execute 'onoremap <silent> a' .. char .. ' :normal va' .. char .. '<CR>'
# endfor


# # (:h emacs-keys) For Emacs-style editing on the command-line:
# # Default keys are in :h cmdline-editing
# # start of line
# :cnoremap <C-A> <Home>
# # back one character
# :cnoremap <C-B> <Left>
# # delete character under cursor (Fn-Backspace is Del in MacOs)
# # :cnoremap <C-D> <Del>
# # end of line
# :cnoremap <C-E> <End>
# # forward one character
# :cnoremap <C-F> <Right>
# # recall newer command-line
# :cnoremap <C-N> <Down>
# # recall previous (older) command-line
# :cnoremap <C-P> <Up>
#
# XXX: <esc> key combination causes delay in dismissing ':' command
# # esc-b is backward-one-word
# :cnoremap <Esc>b <S-Left>
# # esc-f is forward-one-word
# :cnoremap <Esc>f <S-Right>
# # back one word, Alt-B -> not used to using this
# :cnoremap â		<S-Left>
# :cnoremap ∫		<S-Left>
# :cnoremap ļ		<S-Left>
# # forward one word, Alt-F -> not used to using this
# :cnoremap æ		<S-Right>
# :cnoremap ƒ		<S-Right>
# :cnoremap ń		<S-Right>
# :cnoremap <C-h> <S-Left>
# :cnoremap <C-l> <S-Right>

##
## Following keybindings are useful when not using scope.vim
##

# # Open the first file in the popup menu when <cr> is entered
# augroup SelectFirstChoice | autocmd!
#     def SelectFirstChoice()
#         var context = getcmdline()->matchstr('\v\S+\ze\s')
#         if context =~ '\v^(fin|find|e|ed|edit)!{0,1}$'
#             var prefix = getcmdline()->matchstr('\v\S+\s+\zs.+')
#             if !prefix->empty()
#                 var choices = getcompletion(prefix, 'file_in_path')
#                 if !choices->empty()
#                     setcmdline($'{context} {choices[0]}')
#                 endif
#             endif
#         elseif context =~ '\v^(b|bu|buf|buffer)!{0,1}$'
#             var prefix = getcmdline()->matchstr('\v\S+\s+\zs.+')
#             if !prefix->empty()
#                 var choices = getcompletion(prefix, 'buffer')
#                 if !choices->empty()
#                     setcmdline($'{context} {choices[0]}')
#                 endif
#             endif
#         endif
#     enddef
#     autocmd CmdlineLeave : SelectFirstChoice()
# augroup END

# def FindFunc(pat: string, dir: string): list<string>
#     return systemlist('find')
# enddef
# def! g:FindFuncHere(carg: string, addstar: bool): list<string>
#     var pat = addstar ? $'{carg}*' : carg
#     return FindFunc(pat, '.')
# enddef
# set findfunc=FindFuncHere


if &findfunc == null_string && exists(':Find') != 2
    # NOTE: 'find' respects 'path' and 'suffixesadd' while 'edit' does not
    set path=.,,
    set wildignore=.gitignore,*.swp,*.zwc,tags
    nnoremap <leader><space> :fin **/*
    # nnoremap <leader><space> :e **/
    # find file in the parent git root directory
    nnoremap <leader>ff :fin <c-r>=system("git rev-parse --show-toplevel 2>/dev/null \|\| true")->trim()<cr>/**/
    nnoremap <leader>fv :fin $HOME/.vim/**/
    nnoremap <leader>fV :fin $VIMRUNTIME/**/
else
    nnoremap <leader>ff :e <c-r>=system("git rev-parse --show-toplevel 2>/dev/null \|\| true")->trim()<cr>/**/
endif

# note: <home>, <c-left>, <left> etc. move the cursor
# nnoremap <leader>fG :vim /\v/gj **<c-left><left><left><left><left>
# <cword>
# nnoremap <leader>vG :vim /\<<c-r>=expand("<cword>")<cr>\>/gj **
# case sensitive grep
# nnoremap <leader>fG :vim /\v\C/gj **<c-left><left><left><left>
#
# send output of g// to quickfix
#  - following solution does not open qf automatically
#    g/<pattern>/caddexpr expand("%") . ":" . line(".") . ":" . getline(".")
#  - instead of above, use vimgrep
# nnoremap <leader>fg :vim /\v/gj %<left><left><left><left><left>
# Search lines within file
nnoremap <leader>/ :vimgrep /\v/gj %<left><left><left><left><left>


# tag search
nnoremap <leader>ft :tj<space>

# grep equivalents (-E is like \v magic in Vim; no need to escape |, (, ), ., ?, etc. Ex. egrep "import|more"
#   to make it case sensitive, remove '-i'
#   to search specific directory, and for C files, do <dir>/**/*.c
#   you can exclude directories or files using '~' (see zsh config file)
#   ':cw[indow]' opens (toggles) quickfix list only when it is non-empty
# nnoremap <leader>g :cgetexpr system('grep -EInsi "" **/*')\|cw<c-left><left><left>
# nnoremap <leader>G :cgetexpr system('grep -EInsi <c-r>=expand("<cword>")<cr> **/*')\|cw<c-left><left>

# highlight groups ([-1] forces empty string as return value of setqflist())
nnoremap <leader>fh :<c-r>=setqflist([], ' ', #{title: 'highlight', items: execute("hi")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
# others
nnoremap <leader>fk :<c-r>=setqflist([], ' ', #{title: 'keymap', items: execute("verbose map")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
nnoremap <leader>fm :<c-r>=setqflist([], ' ', #{title: 'marks', items: execute("marks")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
nnoremap <leader>fr :<c-r>=setqflist([], ' ', #{title: 'registers', items: execute("registers")->split("\n")->mapnew('{"text": v:val}')})[-1]<cr>copen<cr>
nnoremap <leader>fq <cmd>chistory<cr>

# :h collapse
# These two mappings reduce a sequence of empty (;b) or blank (;n) lines
# into a single line
# :map ;b   GoZ<Esc>:g/^$/.,/./-j<CR>Gdd
# :map ;n   GoZ<Esc>:g/^[ <Tab>]*$/.,/[^ <Tab>]/-j<CR>Gdd
