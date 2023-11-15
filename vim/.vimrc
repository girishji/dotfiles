if !has('vim9script') ||  v:version < 900
    echoe "Needs Vim version 9.0 and above"
    finish
endif

vim9script

#---------------------
# Essential
#---------------------

g:mapleader = "\<Space>"
g:maplocalleader = "\<Space>" # meant for certain file types
map <BS> <Leader>

# Cursor shape changes to show which mode you are in (:h t_SI)
&t_SI = "\e[6 q" #SI = INSERT mode
&t_SR = "\e[4 q" #SR = REPLACE mode
&t_EI = "\e[2 q" #EI = NORMAL mode (ALL ELSE)
# reset the cursor on start
autocmd VimEnter,VimResume * silent execute '!echo -ne "\e[2 q"' | redraw!


augroup FTOptions | autocmd!

#---------------------
# Navigation and Search
#---------------------
# - When you are just exploring new project you search for filenames and symbols within them
#     - use fzf (or :edit :file :grep)
# - When you have some idea you look for specific symbols and their definitions
#     - use lsp (or :ilist :dlist :tags)
# - :h gnavigation

# NOTE: use 'gf' to open files under import statements or #include
# :find uses 'path', while :edit does not. Both respect wildignore. Both open file.
# '**' refers to directories. Recursively search directories (ex> :e **/foo, :e **/*foo)
# :checkpath!  " to list all included files
# set path-=/usr/include
# https://www.youtube.com/watch?v=Gs1VDYnS-Ac 24:00
set path=.,**
# path set to '**' ignores wildignore dirs because it does not use full path
# set wildignore appropriately
# https://vi.stackexchange.com/questions/15457/what-does-wildignore-actually-do-and-what-functions-tools-respect-it
# https://stackoverflow.com/questions/4296201/vim-ignore-special-path-in-search
# */build/* form is needed for :find to ignore, while build/ is needed for :edit to ignore 'build' dir.
set wildignore+=*/build/*,build/,*/pycache/*,pycache/,*/venv/*,venv/,*/dist/*,dist/,*.o,*.obj
# NOTE: Following are set through CmdComplete plugin
# set wildmenu|set wildmode=longest:full:lastused,full|set wildoptions=pum

# Note:
#   :find does not show full path (if you set path to '**'), except when same filename is in different dirs
#   :edit does not ignore dirs when used with '**'
# nnoremap <leader>f :call feedkeys(":find \<Tab>", 'tn')<cr>

# Note: problem with wildcharm is that it automatically inserts first item in menu
# :set wildcharm=<c-z>
# nnoremap <leader><space> :find<space><c-z>

# Note: need autosuggest plugin for following mappings
# nnoremap <leader><space> :e<space>**/*<left>
# Note: Following works (respects wildignore) but slow
nnoremap <leader>f :e<space>**/

nnoremap <leader><space> :Find<space>
nnoremap <leader>g :Grep<space>
nnoremap <expr> <leader>G $':Grep {expand("<cword>")}'
nnoremap <expr> <leader>vg $':silent grep {expand("<cword>")}'
nnoremap <leader><tab> :Keymap<space>

nnoremap <leader><bs> :Buffer<space>
nnoremap <leader>B :buffer<space>
# nnoremap <leader><bs> :buffer<space>
# nnoremap <leader>B :Buffer<space>

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
# List matches and select to jump to.
nnoremap <leader>i :AutoSuggestDisable<CR>[I:let nr = input("Which one: ")<Bar>exe "normal " .. nr .. "[\t"<Bar>AutoSuggestEnable<CR>

# Convince java that 'class' is a macro like C's #define
autocmd FTOptions FileType java setlocal define=^\\s*class
autocmd FTOptions FileType python,vim setlocal define=^\\s*def

if filereadable('./cscope.out')
    cscope add ./cscope.out
elseif filereadable('./../cscope.out')
    cscope add ./../cscope.out
elseif filereadable(expand('~/cscope/cscope.out'))
    cscope add ~/cscope/cscope.out
endif

# ctags will search the following for 'tags' file
# default:
# set tags=./tags,./../tags,./*/tags
set tags=./tags,./../tags,./../../tags,./*/tags

# https://www.reddit.com/r/vim/comments/7bj837/favorite_console_tools_to_use_with_vim/
# Workflow: Sometimes I have to look through a lot of files for a needle in a
# haystack, not something I can grep for because I don't know what it will
# look like, but I will know it when I see it.
# My workflow for this tends to be to create a list of files I need to visit in
# a buffer with find then I go through them quickly using `gf` then bounce back
# using <C-o> and mark that file as checked by deleting it with dd.
# See below about using :argadd
# nnoremap <leader>vF :enew \| :r !find . -type f -name "*.log"<left>

# Open all files of a certina type.
# you can use :arga[dd] **/*.c open all the .c files in your project
# nnoremap <expr> <leader>vf $':argadd **/*.{expand("%:e")}'

# Certain lines marked by a pattern need attention. Put them in quickfix list.
# Since caddexpr is not compatible with opening qf-list automatically, open it
# manunally :copen or :cwindow or <leader>vc
nnoremap <leader>vg :g//caddexpr $'{expand("%")}:{line(".")}:{getline(".")}'<c-left><c-left><right><right>



#---------------------
# AUTOCOMPLETE:
#---------------------

# ctrl-n is the easiest way to autocomplete (ctrl-p for backwards selection)
# Insert a <Tab> if after whitespace, else start a <c-n> completion
def WhitespaceOnly(): bool
    # strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
    return strpart(getline('.'), col('.') - 2, 1) =~ '^\s*$'
enddef
inoremap <expr> <Tab>   WhitespaceOnly() ? "\<tab>" : "\<c-n>"
inoremap <expr> <s-Tab> WhitespaceOnly() ? "\<s-tab>" : "\<c-p>"

# Let omnicomplete (<c-x><c-o>) complete keywords from syntax file
# if has("autocmd") && exists("+omnifunc")
#     autocmd Filetype *
#                 \ if &omnifunc == "" |
#                 \   setlocal omnifunc=syntaxcomplete#Complete |
#                 \ endif
# endif



#---------------------
# Abbreviations
#---------------------
# https://vonheikemen.github.io/devlog/tools/using-vim-abbreviations/
# <c-c> instead of <esc> to prevent expansion
# <c-v> to avoid the abbrev expansion in Insert mode (alternatively, <esc>i)
# <c-v> twice to avoid the abbrev expansion in command-line mode
# :ab - to list all abbreviations (a way to debug)
# https://github.com/LucHermitte/lh-brackets
# Put a space after abbrev keyword for multiline abbrevs (https://vim.fandom.com/wiki/Multi-line_abbreviations)
# Trigger abbrev without typing <space> by using <c-]>
# Abbrevs are not recursive (cannot put one inside another) but you can overcome it using :normal cmd
# (https://gurdiga.com/blog/2016/04/08/vim-recursive-iabbrev/)
def Eatchar(): string
    var c = nr2char(getchar(0))
    return (c =~ '\s') ? '' : c
enddef

def NotCtx(): bool
    return synID(line('.'), col('.') - 1, 1)->synIDattr('name') =~? '\vcomment|string|character|doxygen'
enddef

def EOL(): bool
    return col('.') == col('$') || getline('.')->strpart(col('.')) =~ '^\s\+$'
enddef

def HelpAbbrevs()
    iabbr <buffer> --- ------------------------------------------------------------------------------<c-r>=<SID>Eatchar()<cr>
enddef

def VimAbbrevs()
    iabbr <buffer> #--- #------------------------------<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer><expr> augroup <SID>NotCtx() ? 'augroup' : 'augroup  \| autocmd!<cr>augroup END<esc>k_ela<c-r>=<SID>Eatchar()<cr>'
    iabbr <buffer><expr> def     <SID>NotCtx() ? 'def' : 'def <c-o>oenddef<esc>k_ffla<c-r>=<SID>Eatchar()<cr>'
    iabbr <buffer><expr> def!    <SID>NotCtx() ? 'def!' : 'def! <c-o>oenddef<esc>k_ffla<c-r>=<SID>Eatchar()<cr>'
    iabbr <buffer><expr> if      <SID>NotCtx() ? 'if' : 'if <c-o>oendif<esc>k_ela<c-r>=<SID>Eatchar()<cr>'
    iabbr <buffer><expr> while   <SID>NotCtx() ? 'while' : 'while <c-o>oendwhile<esc>k_ela<c-r>=<SID>Eatchar()<cr>'
    iabbr <buffer><expr> for     <SID>NotCtx() ? 'for' : 'for <c-o>oendfor<esc>k_ela<c-r>=<SID>Eatchar()<cr>'
enddef

def TextAbbrevs()
    iabbr <buffer> vimhelpfmt vim:tw=78:ts=8:noet:ft=help:norl:<c-r>=<SID>Eatchar()<cr>
enddef

def GetSurroundingFn(): string
    var fpat = '\vdef\s+\zs\k+'
    var lnum = search(fpat, 'nb')
    if lnum > 0
        var fname = getline(lnum)->matchstr(fpat) .. '()'
        var cpat = '\vclass\s+\zs\k+'
        lnum = search(cpat, 'nb')
        if lnum > 0
            return getline(lnum)->matchstr(cpat) .. '().' .. fname
        endif
        return fname
    endif
    return ''
enddef

def PythonAbbrevs()
    iabbr <buffer><expr> def     <SID>NotCtx() ? 'def' : 'def ():<cr>"""."""<esc>-f(i<c-r>=<SID>Eatchar()<cr>'
    # iabbr <buffer><expr> defa    def ():<c-o>o'''<cr>>>> print()<cr><cr>'''<esc>4k_f(i<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       trya try:
                \<cr>pass
                \<cr>except Exception as err:
                \<cr>print(f"Unexpected {err=}, {type(err)=}")
                \<cr>raise<cr>else:
                \<cr>pass<esc>5kcw<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       __main__
                \ if __name__ == "__main__":
                \<cr>import doctest
                \<cr>doctest.testmod()<esc><c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       ''' '''
                \<cr>>>> print(<c-r>=<SID>GetSurroundingFn()<cr>)
                \<cr>'''<esc>ggOfrom sys import stderr<esc>Go<c-u><esc>o<esc>
                \:normal i__main__<cr>
                \?>>> print<cr>:nohl<cr>g_hi<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       """ """<cr><cr>"""<c-o>-<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       enum_   Color = Enum('Color', ['RED', 'GRN'])<esc>_fC<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       pre      print(, file=stderr)<esc>F,i<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       pr      print()<c-o>i<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       tuple_named Point = namedtuple('Point', ('x', 'y'), defaults=(None,) * 2)<esc>_<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       namedtup Point = namedtuple('Point', ('x', 'y'))<esc>_<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       zip_longest itertools.zip_longest(<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       pairwise_ itertools.pairwise(<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       Counter_  collections.Counter()<c-o>i<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       chain_    itertools.chain(<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       chain_iter  itertools.chain.from_iterable()<c-o>i<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       dict_default1 collections.defaultdict(int)<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       dict_default2 collections.defaultdict(str)<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       dict_default3 collections.defaultdict(lambda: '[default value]')<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       heapq_nlargest  heapq.nlargest(<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       heapq_nsmallest heapq.nsmallest(<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       __init__ def __init__(self):<esc>hi<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       __add__ def __add__(self, other):<cr><c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       __sub__ def __sub__(self, other):<cr><c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       __mul__ def __mul__(self, other):<cr><c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       __truediv__ def __truediv__(self, other):<cr><c-r>=<SID>Eatchar()<cr>
    iabbr <buffer>       __floordiv__ def __floordiv__(self, other):<cr><c-r>=<SID>Eatchar()<cr>

enddef

def CmakeAbbrevs()
    iabbr <buffer> if() if() <c-o>end()<esc>k_f(a<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer> foreach() foreach(var IN )<c-o>endforeach()<esc>k_f)i<c-r>=<SID>Eatchar()<cr>
    iabbr <buffer> function() function()<c-o>endfunction()<esc>k_f(a<c-r>=<SID>Eatchar()<cr>
enddef

def InsertDashes(): string
    var s = ''
    for _ in range(getline(line('.') - 1)->len())
        s = s .. '-'
    endfor
    return s
enddef

def CommonAbbrevs()
    iabbr <buffer> --* <esc>d^a<c-r>=repeat('-', getline(line('.') - 1)->trim()->len())<cr><c-r>=<SID>Eatchar()<cr>
enddef

augroup FTOptions
    au FileType vim VimAbbrevs()
    au FileType text,help TextAbbrevs()
    au FileType python PythonAbbrevs()
    au FileType help HelpAbbrevs()
    au FileType cmake CmakeAbbrevs()
    au BufEnter * CommonAbbrevs()
augroup END

# cmdline abbrevs
cabbr <buffer> align   s/\v(.*)#(.*)/\=printf("%-16s %s", submatch(1), submatch(2))/<c-r>=g:Eatchar()<cr>



#---------------------
# Options
#---------------------

# Some sane defaults since vim8
# https://github.com/vim/vim/blob/master/runtime/defaults.vim
source $VIMRUNTIME/defaults.vim
# NOTE: $VIMRUNTIME/ftplugin/python.vim sets tabstop, shiftwidth, etc.

# set listchars=tab:→\ ,trail:~
set listchars=tab:→·,trail:~
set list

set fillchars=vert:│,fold:۰,diff:·
set clipboard=unnamed # Always use the system clipboard
set number # line numbering
set relativenumber
set hls # highlight search
set lbr # line break
set laststatus=2 # always show statusline
set hidden # buffer becomes hidden (not unloaded) when it is abandoned (ex. help buffer)
set nojoinspaces # suppress inserting two spaces between sentences
set shortmess+=I # disable startup message
set report=0 # show yank confirmation even if 1 or 2 lines yanked
set showmatch # show matching braces when text indicator is over them
set ignorecase # case-sensitive search
set smartcase # smart search
set infercase # when doing <c-n/p> completion, respect case
set splitbelow # open new split panes to right
set splitright # open new split panes to bottom
set breakindent # wrapped line will continue visually indented
set smarttab
set spellsuggest=best,10 # set maximum number of suggestions listed top 10 items:
set foldmethod=indent
set nofoldenable # do not do folding when you open file
set complete-=i # disable completing keywords from included files (e.g., #include in C)
set signcolumn=yes # always show column for lsp diagnostics etc
set dictionary+=/usr/share/dict/words
set whichwrap+=<,>,h,l # make arrows and h, l, push cursor to next line
# set pumheight=7 # max number of items in popup menu (pmenu)
# ctags can get slow if it seaches dirs for tags file
set tags=./tags,./../tags,./*/tags # this dir, just one level above, and all subdirs
# set tags=~/git/zmk/app/tags

autocmd FTOptions FileType vim,cmake,sh,zsh setl sw=4|setl ts=8|setl sts=4|setl et

#--------------------
# Syntax highlighting
#--------------------

syntax on # turn on syntax highlighting

def MyHighlights()
    exec $'highlight LspDiagVirtualTextError ctermbg={&background == "dark" ? 0 : 7} ctermfg=1 cterm=underline'
    exec $'highlight LspDiagVirtualTextWarning ctermbg={&background == "dark" ? 0 : 7} ctermfg=3 cterm=underline'
    exec $'highlight LspDiagVirtualTextHint ctermbg={&background == "dark" ? 0 : 7} ctermfg=2 cterm=underline'
    exec $'highlight LspDiagVirtualTextInfo ctermbg={&background == "dark" ? 0 : 7} ctermfg=5 cterm=underline'
    highlight link LspDiagSignErrorText LspDiagVirtualTextError
    highlight link LspDiagSignWarningText LspDiagVirtualTextWarning
    highlight link LspDiagSignHintText LspDiagVirtualTextHint
    highlight link LspDiagSignInfoText LspDiagVirtualTextInfo
    if execute('colorscheme') =~ 'quiet'
        highlight Comment ctermfg=244
        highlight LineNr ctermfg=244
        highlight PreProc cterm=bold
        highlight helpHyperTextJump cterm=underline
        highlight helpHyperTextEntry cterm=italic
        highlight helpHeader cterm=bold
        highlight AS_SearchCompletePrefix ctermfg=220
        highlight Pmenu ctermfg=none ctermbg=238 cterm=none guifg=#f8f8f2 guibg=#646e96 gui=NONE
        highlight PmenuSel ctermfg=none ctermbg=28 cterm=bold guifg=#282a36 guibg=#50fa7b gui=NONE
        highlight PmenuKind ctermfg=246 ctermbg=238 cterm=none guifg=#f8f8f2 guibg=#646e96 gui=NONE # 'kind' portion of completion item
        highlight! link PmenuKindSel PmenuSel
        highlight! link PmenuExtra PmenuKind # 'extra' text of completion item
        highlight! link PmenuExtraSel PmenuSel
        # Following is experimental
        # highlight String cterm=italic
        # highlight Function cterm=underline
    elseif execute('colorscheme') =~ 'slate'
        highlight Comment ctermfg=246
        highlight Type ctermfg=71 cterm=bold
        highlight ModeMsg ctermfg=235 ctermbg=220 cterm=reverse
    endif
enddef

augroup MyColors | autocmd!
    # slate or zaibatsu:
    # autocmd FileType c,cmake ++nested colorscheme slate
    # Trailing spaces show up in red
    autocmd ColorScheme * highlight TrailingWhitespace ctermbg=196
                \ | match TrailingWhitespace /\s\+\%#\@<!$/
                \ | MyHighlights()
augroup END



#--------------------
# Autocommands
#--------------------

# Save yank'ed text into numbered registers and rotate. By default vim
# stores yank into "0 (does not rotate) and stores deleted and changed text
# into "1 and rotates (:h #1). If deleted text is less than a line it is also
# stored in "- register (aka small delete register).
def SaveLastReg()
    if v:event['regname'] == "" && v:event['operator'] == 'y'
        for i in range(8, 1, -1)
            setreg(string(i + 1), getreg(string(i)))
        endfor
        @1 = v:event['regcontents'][0]
    endif
enddef

augroup myCmds | autocmd!
    autocmd TextYankPost * SaveLastReg()
    # windows to close
    autocmd FileType help,vim-plug,qf nnoremap <buffer><silent> q :close<CR>
    # create directories when needed, when saving a file
    autocmd BufWritePre * mkdir(expand('<afile>:p:h'), 'p')
    # Disable continuation of comment marker when new line is opened
    autocmd FileType * set formatoptions-=cro
    # Tell vim to automatically open the quickfix and location window after :make,
    # :grep, :lvimgrep and friends if there are valid locations/errors:
    # NOTE: Does not work with caddexpr (:g/pat/caddexpr ...) since it adds entries, so exclude [^c]
    autocmd QuickFixCmdPost [^lc]* cwindow
    autocmd QuickFixCmdPost l*     lwindow
    # update tags in help file
    autocmd BufWritePost **/doc/*.txt helptags <afile>:p:h
    # make help files writeable
    autocmd BufEnter **/doc/*.txt set modifiable noreadonly
    # list help files in buffer list (can type :ls instead of :ls!)
    # autocmd FileType help set buflisted
    # :h template
    # autocmd BufNewFile *.txt  r ~/.vim/skeleton.txt
    # autocmd BufNewFile *.cpp  r ~/.vim/skeleton.cpp
    # spell
    # autocmd FileType help,text,markdown set spell
    autocmd FileType text,markdown set spell
    # :retab to change tab characters to match existing settings
    # :expandtab replaces tab to spaces
    # gitdiff by default uses 8 for tab width
    # Use <c-v><tab> to insert real tab character
    autocmd FileType c,cpp,java,vim set softtabstop=4 shiftwidth=4 expandtab
    # Remove any trailing whitespace that is in the file
    autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
    # for competitive programming  (book by Antti Laaksonen); install gcc using homebrew
    # autocmd FileType cpp,c setlocal makeprg=g++\ -std=c++11\ -O2\ -Wall\ %\ -o\ %<
    #
    autocmd FileType python PythonCustomization()
augroup END


def PythonCustomization()
    # NOTE: tidy-imports misses some imports. Put them in ~/.pyflyby
    # python help (:redraw! will fix any screen issues after shell command)
    nnoremap <buffer> <leader>vh :term ++close pydoc3<space>
    nnoremap <buffer> <leader>vb :!open https://docs.python.org/3/search.html\?q=
    nnoremap <buffer> <leader>vi :% !tidy-imports --replace-star-imports -r -p --quiet --black<cr>
    nnoremap <buffer> <leader>vf :% !black -q -<cr>
    nnoremap <buffer><expr> <leader>vt $":new \| exec 'nn <buffer> q :bd!\<cr\>' \| 0read !leetcode test {bufname()->fnamemodify(':t')->matchstr('^\d\+')}<cr>"
    nnoremap <buffer><expr> <leader>vx $":new \| exec 'nn <buffer> q :bd!\<cr\>' \| 0read !leetcode exec {bufname()->fnamemodify(':t')->matchstr('^\d\+')}<cr>"
    nnoremap <buffer><expr> <leader>vp $":new \| exec 'nn <buffer> q :bd!\<cr\>' \| r ! python3 #<cr>"
    setlocal makeprg=python3\ %
    nnoremap <buffer> <leader>p :Ipython<cr>
    &l:formatprg = "black --quiet -"
enddef

#--------------------
# Commands
#--------------------

def Ipython()
    var listedbufs = getbufinfo({buflisted: 1})
    var ipbufidx = listedbufs->indexof((_, v) => v.name =~? 'ipython')
    if ipbufidx != -1
        var ipbufnr = listedbufs[ipbufidx].bufnr
        if bufwinnr(ipbufnr) == -1
            echom listedbufs[ipbufidx].bufnr
            # ipython opthons can be placed in a config file
            exec $'sbuffer {listedbufs[ipbufidx].bufnr}'
        endif
    else
        :term ++close ++kill=term ipython3 --no-confirm-exit --colors=Linux
    endif
enddef
command Ipython Ipython()

# Find highlight group under cursor
def SynStack()
    if !exists("*synstack") | return | endif
    echo synstack(line('.'), col('.'))->map('synIDattr(v:val, "name")')
enddef
command HighlightGroupUnderCursor SynStack()

# Toggle folding of all folds in buffer (zR, zM)
var myfoldingtoggleflag = false
def FoldingToggle()
    exec myfoldingtoggleflag ? 'normal! zR' : 'normal! zM'
    myfoldingtoggleflag = !myfoldingtoggleflag
enddef

# git diff
def GitDiffThisFile()
    var fname = resolve(expand('%:p'))
    var dirname = fname->fnamemodify(':p:h')
    exec $'!cd {dirname};git diff {fname}; cd -'
enddef
command GitDiffThisFile GitDiffThisFile()

# Preview with GitHub Markdown
var markdown_preview_job: job
def OpenMarkdownPreview()
    if markdown_preview_job->job_status() != 'run'
        markdown_preview_job = job_start('grip')
    endif
    sleep 500m
    silent exec '!open http://localhost:6419/' .. expand('%')
enddef
command PreviewMarkdown OpenMarkdownPreview()

def StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        :normal mz
        :normal Hmy
        :%s/\s\+$//e
        :normal 'yz<CR>
        :normal `z
    endif
enddef
command StripTrailingWhitespace StripTrailingWhitespace()



#--------------------
# Keybindings
#--------------------

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
# Make it easy to enter commands and navigate with f, F, t, T
# nnoremap ; :
# nnoremap , ;
# nnoremap : ,
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
# visually select recent pasted text (or changed text);
nnoremap ga `[v`]
# Type %% on Vim’s command-line prompt, it expands to the path of the active buffer
# cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') .. '/' : '%%'
# <leader> mappings
nnoremap <leader>b <cmd>b#<cr>| # alternate buffer
nnoremap <leader>d <cmd>bdelete<cr>| # use :hide instead
nnoremap <leader>h <cmd>hide<cr>| # hide window
nnoremap <leader>u <cmd>unhide<cr><c-w>w| # unhide window
tnoremap <c-w>h <c-w>:hide<cr>| # hide window
nnoremap <leader>t <cmd>!tree <bar> more<cr>
nnoremap <leader>w <cmd>w<cr>
nnoremap <leader>q <cmd>qa<cr>
nnoremap <leader>Q <cmd>qa!<cr>
nnoremap <leader>n <cmd>only<cr>
nnoremap <leader>- <c-w>s| # horizontal split
nnoremap <leader>\| <c-w>v| # vertical split
nnoremap <leader>o <c-w>w| # next window in CCW direction
nnoremap <leader>r <cmd>registers<cr>
nnoremap <leader>m <cmd>marks<cr>
vnoremap <leader>a :!column -t| # align columns
# Vim group
nnoremap <leader>vs :set spell!<CR><Bar>:echo "Spell Check: " .. strpart("OffOn", 3 * &spell, 3)<CR>
nnoremap <leader>vr :new \| exec "nn <buffer> q :bd!\<cr\>" \| r ! | # redirect shell command, use :il /foo to filter lines
nnoremap <leader>vR :enew \| exec "nn <buffer> q :bd!\<cr\>" \| put = execute('map')<left><left>| # redirect vim cmd, use <leader>fi to filter
nnoremap <expr> <leader>vc empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
nnoremap <expr> <leader>vL empty(filter(getwininfo(), 'v:val.loclist')) ? ':lopen<CR>' : ':lclose<CR>'
nnoremap <leader>vl <cmd>set buflisted!<cr>
nnoremap <leader>vm <cmd>messages<cr>
nnoremap <leader>vd <cmd>GitDiffThisFile<cr>
nnoremap <leader>vD <cmd>DiffOrig<cr>
nnoremap <leader>ve <cmd>e ~/.vimrc<cr>
nnoremap <leader>vz <scriptcmd>FoldingToggle()<cr>
nnoremap <leader>vp <cmd>echo expand('%')<cr>



#--------------------
# Plugins
#--------------------

# Disable netrw plugin. It defines :Hexplore which shares letter with :Help.
g:loaded_netrwPlugin = 1
g:loaded_netrw = 1

# This loads the "matchit" plugin; It makes the % command more powerful, but
# bracket matching gets much slower. Vim's default bracket matching does not
# avoid commented brackets through. and this plugin avoids that.
if has('syntax') && has('eval')
    packadd! matchit
endif

# Download plug.vim if it doesn't exist yet
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

# Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) > 0
            \| PlugInstall --sync | source ~/.vimrc
            \| endif

plug#begin("~/.vim/plugged")
# Make sure you use single quotes
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
# Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
# Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'yegappan/lsp'
# Plug '~/git/lsp'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
# XXX python-syntax does not highlight 'dectest' (test code inside comments)
# Plug 'vim-python/python-syntax'
#
# Plug '~/git/autosuggest.vim'
Plug 'girishji/autosuggest.vim'
# Plug '~/git/declutter.vim'
# Plug 'girishji/declutter.vim'
Plug 'girishji/bufline.vim'
# Plug '~/git/bufline.vim'
# Plug '~/git/vimcomplete'
Plug 'girishji/vimcomplete'
# Plug '~/git/ngram-complete.vim'
Plug 'girishji/ngram-complete.vim'
# Plug '~/git/vimscript-complete.vim'
Plug 'girishji/vimscript-complete.vim'
# Plug 'girishji/omnifunc-complete.vim'
Plug 'girishji/vsnip-complete.vim'
Plug 'girishji/omnifunc-complete.vim'
Plug 'girishji/lsp-complete.vim'
Plug 'girishji/pythondoc.vim'
plug#end()


#--------------------
# pythondoc

g:pythondoc_hh_expand = 1

#--------------------
# vimcomplete

g:vimcomplete_tab_enable = 1

var vcoptions = {
    completor: { shuffleEqualPriority: true },
    buffer: { enable: true, priority: 11, urlComplete: true, envComplete: true },
    abbrev: { enable: true, priority: 10 },
    lsp: { enable: true, priority: 10, maxCount: 10 },
    omnifunc: { enable: false, priority: 10, filetypes: ['python', 'javascript'] },
    vsnip: { enable: true, priority: 10, adaptNonKeyword: true },
    vimscript: { enable: true, priority: 10 },
    ngram: {
        enable: true,
        priority: 10,
        bigram: false,
        filetypes: ['text', 'help', 'markdown'],
        filetypesComments: ['c', 'cpp', 'python', 'java', 'lua', 'vim', 'zsh', 'r'],
    },
}
autocmd VimEnter * g:VimCompleteOptionsSet(vcoptions)

#--------------------
# autosuggest

var options = {
    search: {
        pum: true,
        fuzzy: false,
        hidestatusline: false,
        alwayson: true,
    },
    cmd: {
        enable: true,
        pum: true,
        hidestatusline: false,
        fuzzy: false,
        # exclude: ['^buffer ', '^F'],
        # onspace: ['buffer', 'Find'],
        onspace: ['buffer'],
        editcmdworkaround: true,
    }
}
autocmd VimEnter * g:AutoSuggestSetup(options)

#--------------------
# declutter

# colorscheme declutter-minimal
# colorscheme declutter
colorscheme quiet

#--------------------
# lsp
var clangdpath = exepath('clangd')
if clangdpath->empty()
    clangdpath = expand("$HOMEBREW_PREFIX") .. '/opt/llvm/bin/clangd',
endif
var lspServers = [
    {
        name: 'clang',
        filetype: ['c', 'cpp'],
        path: clangdpath,
        args: ['--background-index']
    },
    # {
    #     name: 'pylsp',
    #     filetype: 'python',
    #     path: exepath('pylsp'),
    #     args: [],
    #     # debug: true,
    #     # workspaceConfig: {
    #     #     plugins: {
    #     #         # pylint: { enabled: true }
    #     #         # autopep8: { enabled: false }
    #     #     }
    #     # },
    # },
    {
        name: 'pyright',
        filetype: 'python',
        path: exepath('pyright-langserver'),
        args: ['--stdio'],
        # debug: true,
        # https://github.com/microsoft/pyright/blob/main/docs/settings.md
        workspaceConfig: {
            python: {
                # pythonPath doesn't seem to work
                # pythonPath: ['/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages'],
                analysis: {
                    autoSearchPaths: true,
                    diagnosticMode: 'workspace',
                    autoImportCompletions: true,
                    typeCheckingMode: "off", # off, basic, strict
                },
            },
        },
    },
    # {
    #     # Note:
    #     # - use <tab> to place implementation skeleton of method ('t' <tab> <space> you get toString() in jdtls)
    #     # - invoke code action to organize imports
    #     name: 'jdtls',
    #     filetype: 'java',
    #     path: expand("$HOMEBREW_PREFIX") .. '/bin/jdtls',
    #     args: [
    #     "-configuration", expand("$HOME") .. "/.cache/jdtls",
    #     "-data", expand("$HOME") .. "/.local/share/me/eclipse",
    #     ],
    #     # https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line
    #     initializationOptions: {
    #         settings: {
    #             java: {
    #                 contentProvider: { preferred: "fernflower" },
    #                 completion: {
    #                     # exclude the following from completion suggestions
    #                     filteredTypes: [ "com.sun.*", "java.awt.*", "jdk.*",
    #                                 \ "org.graalvm.*", "sun.*", "javax.awt.*",
    #                                 \ "javax.swing.*" ],
    #                 },
    #             },
    #         },
    #     },
    # },
]

autocmd VimEnter * call LspAddServer(lspServers)
# XXX registering for FileType event causes multiple instances of server jobs
# autocmd FileType java,c,cpp,python call LspAddServer(lspServers)

var lspOpts = {
    autoHighlightDiags: true,
    showDiagWithVirtualText: false, # when you set this false, set showDiagOnStatusLine true
    highlightDiagInline: false,
    showDiagOnStatusLine: true,
    diagVirtualTextAlign: 'after',
    autoPopulateDiags: false, # add diags to location list automatically <- :lopen [l ]l
    completionMatcher: 'fuzzy', # case/fuzzy/icase
    # completionMatcher: 'case', # case/fuzzy/icase
    outlineWinSize: 30,
    useBufferCompletion: true,
    completionTextEdit: false,
    snippetSupport: true, # snippets from lsp server
    vsnipSupport: true,
    autoComplete: true,
}
autocmd VimEnter * call LspOptionsSet(lspOpts)

## Make jdtls 'code actions' do 'organize imports', 'add unimplemented methods', etc.,
#var jfname = $'{$HOME}/.vim/plugged/lsp/autoload/lsp/textedit.vim'
#if filereadable(jfname)
#    import jfname
#    def g:JavaWorkspaceEdit(cmd: dict<any>)
#        for editAct in cmd.arguments
#            textedit.ApplyWorkspaceEdit(editAct)
#        endfor
#    enddef
#    autocmd FileType java g:LspRegisterCmdHandler('java.apply.workspaceEdit', g:JavaWorkspaceEdit)
#endif

# toggle diagnostics
g:isLspDiagHighlighted = true
def MyToggleDiagHighlight()
    exec g:isLspDiagHighlighted ? 'LspDiag highlight disable' : 'LspDiag highlight enable'
    g:isLspDiagHighlighted = !g:isLspDiagHighlighted
enddef

def LSPUserSetup()
    # use tag mechanism to jump to location where a symbol is defined (<C-]>, <C-t> to go back, :tags)
    # XXX: tagfunc breaks :cs find g <symbol>
    # setlocal tagfunc=lsp#lsp#TagFunc

    # Format Code: formatexpr is used by 'gq' (NOT 'gw') (messes python with pyright)
    # setlocal formatexpr=lsp#lsp#FormatExpr()
    nnoremap <buffer> <leader>lf <cmd>LspFormat<cr>
    # NOTE: gd, gD work as expected in Vim without LSP (go to definition)
    nnoremap <buffer> <C-W>gd <Cmd>topleft LspGotoDefinition<CR>| # jump to tag definition in split window
    nnoremap <buffer> <leader>lt :call <SID>MyToggleDiagHighlight()<CR>
    nnoremap <buffer> <leader>lH <cmd>LspCallHierarchyOutgoing<cr>
    nnoremap <buffer> <leader>lP <cmd>LspPeekDeclaration<cr>| # open popup
    nnoremap <buffer> <leader>lR <cmd>LspServer restart<cr>
    nnoremap <buffer> <leader>ls <cmd>LspServer show status<cr>
    nnoremap <buffer> <leader>ld <cmd>LspServer debug messages<cr>
    nnoremap <buffer> <leader>la <cmd>LspCodeAction<cr>
    nnoremap <buffer> <leader>lh <cmd>LspCallHierarchyIncoming<cr>
    nnoremap <buffer> <leader>ll <cmd>LspDiagShow<cr>| # add diags to location list
    nnoremap <buffer> <leader>lo <cmd>LspOutline<cr>
    nnoremap <buffer> <leader>lp <cmd>LspPeekDeclaration<cr>
    nnoremap <buffer> <leader>lr <cmd>LspRename<cr>| # rename symbol under cursor
    nnoremap <buffer> <leader>lS <cmd>LspShowSignature<cr>| # for symbol under cursor
    nnoremap <buffer> [e :LspDiagPrev<CR>| # think as 'error' message
    nnoremap <buffer> ]e :LspDiagNext<CR>
    nnoremap <buffer> K :LspHover<CR>
    nnoremap <buffer> gl :LspDiagCurrent<CR>| # display all diag messages under cursor in a popup
    hi LspDiagVirtualText ctermfg=1
    hi LspDiagLine ctermbg=none
    set completepopup+=highlight:normal,border:on
enddef
autocmd User LspAttached LSPUserSetup()

# If your '{' or '}' are not in the first column, and you would like to use "[["
# and "]]" anyway, try these mappings: >
# see :h object-motions
   # :map [[ ?{<CR>w99[{
   # :map ][ /}<CR>b99]}
   # :map ]] j0[[%/{<CR>
   # :map [] k$][%?}<CR>




#--------------------
# highlightedyank
g:highlightedyank_highlight_duration = 300


#--------------------
# gitgutter
g:gitgutter_map_keys = 0
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
hi GitGutterAdd ctermfg=5 | hi GitGutterChange ctermfg=5 | hi GitGutterDelete ctermfg=5
# Disable these problematic autocmds, otherwise :vimgrep gives error when opening quickfix
autocmd VimEnter * autocmd! gitgutter QuickFixCmdPre *vimgrep*
autocmd VimEnter * autocmd! gitgutter QuickFixCmdPost *vimgrep*


#--------------------
# vim-commentary

autocmd FTOptions FileType c,cpp setlocal commentstring=//\ %s |
            \ command! CommentBlock setlocal commentstring=/*%s*/ |
            \ command! CommentLines setlocal commentstring=//\ %s

#--------------------
# Statusline

def Gitstr(): string
    var [a, m, r] = exists('*g:GitGutterGetHunkSummary') ? g:GitGutterGetHunkSummary() : [0, 0, 0]
    return (a + m + r) > 0 ? $' {{git:{a + m + r}}}' : ''
enddef

def Diagstr(): string
    var diagstr = ''
    if exists('lsp#lsp#ErrorCount')
        var diag = lsp#lsp#ErrorCount()
        var Severity = (s: string) => {
            return diag[s] != 0 ? $' {s->strpart(0, 1)}:{diag[s]}' : ''
        }
        diagstr = $'{Severity("Error")}{Severity("Warn")}{Severity("Hint")}{Severity("Info")}'
    endif
    return diagstr
enddef

def! g:MyStatuslineSetup()
    if &background == 'dark'
        set fillchars+=stl:―,stlnc:—
        # guibg is needed to avoid carets, when both active/non-active statusline have same bg
        exec $'highlight statusline cterm=none ctermfg=7 ctermbg=none guibg=red'
        exec $'highlight statuslinenc cterm=none ctermfg=7 ctermbg=none guibg=green'
        highlight user2 cterm=none ctermfg=7 ctermbg=none
        highlight user4 ctermfg=3 cterm=none
    else
        exec $'highlight statusline cterm=none ctermfg=8 ctermbg=7 guibg=red'
        exec $'highlight statuslinenc cterm=none ctermfg=8 ctermbg=7 guibg=green'
        exec $'highlight user1 cterm=none ctermbg=7'
        exec $'highlight user2 cterm=none ctermfg=240 ctermbg=7'
        exec $'highlight user4 cterm=none ctermfg=52 ctermbg=7'
    endif
    highlight! link StatusLineTerm statusline
    highlight! link StatusLineTermNC statuslinenc
    highlight link user3 statusline
    g:BuflineSetup({ highlight: true, showbufnr: true })
enddef

def BuflineStr(width: number): string
    return exists('*g:BuflineGetstr') ? g:BuflineGetstr(width) : ''
enddef

def! g:MyActiveStatusline(): string
    var gitstr = Gitstr()
    var diagstr = Diagstr()
    var shortpath = expand('%:h')
    var shortpathmax = 20
    if shortpath->len() > shortpathmax
        shortpath = shortpath->split('/')->map((_, v) => v->slice(0, 2))->join('/')->slice(0, shortpathmax)
    endif
    var width = winwidth(0) - 30 - gitstr->len() - diagstr->len() - shortpath->len()
    var buflinestr = BuflineStr(width)
    return $'%4*{diagstr}%* {buflinestr} %= {shortpath}%4*{gitstr}%* %y %P (%l:%c) %*'
    # return $'%4*{diagstr}%* {buflinestr} %= %f%4*{gitstr}%* %y %P (%l:%c) %*'
    # return $'{diagstr} {buflinestr} %={gitstr} %y %P (%l:%c) '
enddef

def! g:MyInactiveStatusline(): string
    return ' %F '
enddef

augroup MyStatusLine | autocmd!
    autocmd VimEnter,ColorScheme * g:MyStatuslineSetup()
    autocmd WinEnter,BufEnter,BufAdd * setl statusline=%{%g:MyActiveStatusline()%}
    autocmd User LspDiagsUpdated,BufLineUpdated setl statusline=%{%g:MyActiveStatusline()%}
    autocmd WinLeave,BufLeave * setl statusline=%{%g:MyInactiveStatusline()%}
augroup END

# vim: ts=8 sts=4 sw=4 et fdm=marker
