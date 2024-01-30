vim9script


import autoload 'fuzzy.vim'
nnoremap <leader><bs> <scriptcmd>fuzzy.Buffer()<CR>
nnoremap <leader><space> <scriptcmd>fuzzy.File()<CR>
var findcmd = "find /Users/gp/.vim -type d -path */plugged -prune -o -name *.swp -prune -o -path */.vim/.* -prune -o -type f -print -follow"
# var findcmd = 'fd -tf -L . /Users/gp/.vim'
nnoremap <leader>vv <scriptcmd>fuzzy.File(findcmd, true)<CR>
nnoremap <leader><tab> <scriptcmd>fuzzy.Keymap()<CR>

# nnoremap <leader>g :Grep<space>
# nnoremap <expr> <leader>G $':Grep {expand("<cword>")}'
# nnoremap <leader>G :FGrep<space>


if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable("ag")
    set grepprg=ag\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

# (grep, vimgrep) https://vim.fandom.com/wiki/Find_in_files_within_Vim
#
# NOTE: <c-w> will delete the word before cursor
# Search only files with same extension. Remove *.x to search everywhere.
# nnoremap <expr> <leader>G $':silent grep {expand("<cword>")} {expand("%:e") == "" ? "" : "**/*." .. expand("%:e")}<c-left><left>'
# nnoremap <expr> <leader>vG $':vim /{expand("<cword>")}/gj **{expand("%:e") == "" ? "" : "/*." .. expand("%:e")}<c-left><left><left><left>'
# Search everywhere
# nnoremap <expr> <leader>g $':silent grep {expand("<cword>")}'
# nnoremap <expr> <leader>vg $':vim /{expand("<cword>")}/j **<c-left><left><left><left>'

# symbol-based navigation (:h E387 include-search)
# -----------------------
# Search included files recursively for variable, function or macro (#define).
#
# The commands that start with "[" start searching from the start of the current
# file.  The commands that start with "]" start at the current cursor position.
#
# ilist is for symbols (include), dlist (#define list) looks for 'macros' (in C, it is #define)
#
# [<tab> " go to first occurance (definition, in many casesa). similar to 'gd'
# :ijump Template  " :ij (:dj) jump to first match of 'Template' in includes
# :ij /Tem         " jump to first match of pattern 'Tem' in includes
# :ili[st] /pattern or dli[st] /pattern  " list all symbols / macros
# :is[earch] /pattern/ " Like "[i"  and "]i", but search whole file or range and show first match
# ]i [i	        ]d [d  " same as [id]search except for word under cursor
# [<C-i>	[<C-d> " jump to first line that has symbol/macro
# [I	        [D  " display all lines with matches for word under cursor
nnoremap <leader>fi :ilist<space>/| # search /pattern/ for symbols, <num> [<tab> to jump; Similar as :g /pat except this shows jump numbers
# (girish: above will search all files for variable, fn name etc.)
nnoremap <leader>fd :dlist<space>/| # :dli
# (girish: above will list all #define when you do / and search in all files)


# My workflow for this tends to be to create a list of files I need to visit in
# a buffer with find then I go through them quickly using `gf` then bounce back
# using <C-o> and mark that file as checked by deleting it with dd.
# See below about using :argadd
# nnoremap <leader>vF :enew \| :r !find . -type f -name "*.log"<left>

# Open all files of a certina type.
# you can use :arga[dd] **/*.c open all the .c files in your project
# nnoremap <expr> <leader>vf $':argadd **/*.{expand("%:e")}'

# NOTE: Cannot automatically open quickfix window with caddexpr (:g/pat/caddexpr ...)
#   since it adds entries
# :g search file for pattern and put resulting lines in quickfix list
# cadde[xpr] {expr}	Evaluate {expr} and add the resulting lines to the quickfix list
# Since caddexpr does not open qf-list automatically, open it manunally :copen or :cwindow or <leader>vc
nnoremap <leader>vg :g//caddexpr $'{expand("%")}:{line(".")}:{getline(".")}'<c-left><c-left><right><right>


# ctags will search the following for 'tags' file
# default: set tags=./tags,./../tags,./*/tags

#---------------------
# AUTOCOMPLETE:
#---------------------

# # ctrl-n is the easiest way to autocomplete (ctrl-p for backwards selection)
# # Insert a <Tab> if after whitespace, else start a <c-n> completion
# def WhitespaceOnly(): bool
#     # strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
#     return strpart(getline('.'), col('.') - 2, 1) =~ '^\s*$'
# enddef
# inoremap <expr> <Tab>   WhitespaceOnly() ? "\<tab>" : "\<c-n>"
# inoremap <expr> <s-Tab> WhitespaceOnly() ? "\<s-tab>" : "\<c-p>"

# Let omnicomplete (<c-x><c-o>) complete keywords from syntax file
# if has("autocmd") && exists("+omnifunc")
#     autocmd Filetype *
#                 \ if &omnifunc == "" |
#                 \   setlocal omnifunc=syntaxcomplete#Complete |
#                 \ endif
# endif

# Y mapping, more natural but not vi compatible
map Y y$
# map gm to go to middle of line instead of middle of screen
nnoremap gm gM
# When softwrap happens move by screen line instead of file line
nnoremap j gj
nnoremap k gk
# Jump lines faster (use with H, M, L)
nnoremap <leader>j 5j
nnoremap <leader>k 5k
# g* selects foo in foobar while * selects <foo>, <> is word boundary. make * behave like g*
# nnoremap * g*
# nnoremap # g#
#  Resize window using <ctrl> arrow keys
# nnoremap <silent> <C-Up> :resize +2<cr>
# nnoremap <silent> <C-Down> :resize -2<cr>
# nnoremap <silent> <C-Right> :vertical resize -2<cr>
# nnoremap <silent> <C-Left> :vertical resize +2<cr>
# Buffer navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
# nnoremap <silent> <leader>h :bprevious<CR>
# nnoremap <silent> <leader>l :bnext<CR>
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
nnoremap <silent> <esc> :nohlsearch<CR>
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
nnoremap <leader>d <cmd>bdelete<cr>| # use :hide instead
nnoremap <leader>H <cmd>hide<cr>| # hide window
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
vnoremap <leader>a :!column -t<cr>| # align columns
# Toggle group
nnoremap <leader>ts :set spell!<CR><Bar>:echo "Spell Check: " .. strpart("OffOn", 3 * &spell, 3)<CR>
nnoremap <silent> <leader>tt <cmd>call text#Toggle()<CR>
# Vim group
nnoremap <leader>vr :new \| exec "nn <buffer> q :bd!\<cr\>" \| r ! | # redirect shell command, use :il /foo to filter lines
nnoremap <leader>vR :enew \| exec "nn <buffer> q :bd!\<cr\>" \| put = execute('map')<left><left>| # redirect vim cmd, use <leader>fi to filter
nnoremap <expr> <leader>vc empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
nnoremap <expr> <leader>vL empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'
nnoremap <leader>vl <cmd>set buflisted!<cr>
nnoremap <leader>vm <cmd>messages<cr>
nnoremap <leader>vd <cmd>GitDiffThisFile<cr>
nnoremap <leader>ve <cmd>e ~/.vimrc<cr>
nnoremap <leader>vz <scriptcmd>FoldingToggle()<cr>
nnoremap <leader>vp <cmd>echo expand('%')<cr>

# Notes:
# ======
#
# - :h gnavigation
#
#	  "[{": "Previous {",
#	  "[(": "Previous (",
#	  "[<lt>": "Previous <",
#	  "[m": "Previous method start",
#	  "[M": "Previous method end",
#	  "[%": "Previous unmatched group",
#	  "[s": "Previous misspelled word",
#	  "]{": "Next {",
#	  "](": "Next (",
#	  "]<lt>": "Next <",
#	  "]m": "Next method start",
#	  "]M": "Next method end",
#	  "]%": "Next unmatched group",
#	  "]s": "Next misspelled word",
#	  "H": "Home line of window (top)",
#	  "M": "Middle line of window",
#	  "L": "Last line of window",
#	  "]i": "Search symbol in include file (forward)",
#	  "[i": "Search symbol in include file (backward",
#	  "]d": "Search macro (#define) symbols",
#	  "[d": "Search macro (#define) symbols",
#
# Bram says `[<tab>` will jump to symbol definition. It does look for included
# files and other files in dir. `gd` also goes to definition, but it searches
# within the file and highlights all matches unlike `[<tab>`.
#
#       "gf": open files under import statements or #include
#
# :find uses 'path', while :edit does not. Both respect wildignore. Both open file.
# '**' refers to directories. Recursively search directories (ex> :e **/foo, :e **/*foo)
# :checkpath!  " to list all included files
# set path-=/usr/include
# set path=.,**
# path set to '**' does not consider wildignore dirs because it does not use full path
# set wildignore appropriately
# https://vi.stackexchange.com/questions/15457/what-does-wildignore-actually-do-and-what-functions-tools-respect-it
# https://stackoverflow.com/questions/4296201/vim-ignore-special-path-in-search
# */build/* form is needed for :find to ignore, while build/ is needed for :edit to ignore 'build' dir.
# set wildignore+=*/build/*,build/,*/pycache/*,pycache/,*/venv/*,venv/,*/dist/*,dist/,*.o,*.obj
#
#   :find does not show full path (if you set path to '**'), except when same filename is in different dirs
#   :edit does not ignore dirs when used with '**'
# nnoremap <leader>f :call feedkeys(":find \<Tab>", 'tn')<cr>

# Note: problem with wildcharm is that it automatically inserts first item in menu
# :set wildcharm=<c-z>
# nnoremap <leader><space> :find<space><c-z>
#
# Note: need autosuggest plugin for following mappings
# nnoremap <leader><space> :e<space>**/*<left>
# Note: Following works (respects wildignore) but slow
# nnoremap <leader>ff :e<space>**/

