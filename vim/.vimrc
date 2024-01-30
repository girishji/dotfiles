if !has('vim9script') ||  v:version < 900
    " Needs Vim version 9.0 and above
    finish
endif

vim9script

g:mapleader = "\<Space>"
g:maplocalleader = "\<Space>" # meant for certain file types
map <BS> <Leader>

# To make undercurl work in iterm2 (:h E436, :h t_Cs)
&t_Cs = "\e[4:3m"
&t_Ce = "\e[4:0m"

# Cursor shape changes to show which mode you are in (:h t_SI)
&t_SI = "\e[6 q" #SI = INSERT mode
&t_SR = "\e[4 q" #SR = REPLACE mode
&t_EI = "\e[2 q" #EI = NORMAL mode (ALL ELSE)
# reset the cursor on start
autocmd VimEnter,VimResume * silent execute '!echo -ne "\e[2 q"' | redraw!

# Format usin 'gq'. :h fo-table
set formatoptions=qjl

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
# set relativenumber
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

syntax on # turn on syntax highlighting

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
Plug 'machakann/vim-swap'
Plug 'yegappan/lsp'
# Plug '~/git/lsp'
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
# colorschemes
Plug 'cocopon/iceberg.vim'
#
# Plug '~/git/autosuggest.vim'
Plug 'girishji/autosuggest.vim'
# Plug '~/git/bufline.vim'
Plug 'girishji/bufline.vim'
# Plug '~/git/vimcomplete'
Plug 'girishji/vimcomplete'
# Plug '~/git/ngram-complete.vim'
Plug 'girishji/ngram-complete.vim'
Plug 'girishji/pythondoc.vim', {'for': 'python'}
# Plug '~/git/easyjump.vim'
Plug 'girishji/easyjump.vim'
plug#end()

# vim: ts=8 sts=4 sw=4 et fdm=marker
