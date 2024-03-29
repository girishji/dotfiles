vim9script

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

augroup MyVimrc | autocmd!
    # set unnamed file type to 'txt'
    # autocmd BufEnter * if @% == "" | setfiletype txt | endif
    #
    autocmd FileType cmake,sh,zsh setl sw=4|setl ts=8|setl sts=4|setl et
    autocmd TextYankPost * SaveLastReg()
    # windows to close
    autocmd FileType help,vim-plug,qf {
        nnoremap <buffer> Q q
        nnoremap <buffer><silent> q :close<CR>
    }
    # create directories when needed, when saving a file
    autocmd BufWritePre * mkdir(expand('<afile>:p:h'), 'p')
    # Format usin 'gq'. :h fo-table
    autocmd FileType * setl formatoptions=qjlron
    # Tell vim to automatically open the quickfix and location window after :make,
    # :grep, :lvimgrep and friends if there are valid locations/errors:
    # NOTE: Does not work with caddexpr (:g/pat/caddexpr ...) since it just adds entries.
    # ':make', ':grep' and so on are called quickfix commands, they trigger QuickFixCmdPost.
    # [^l]* to match commands that don't start with l (l* does the opposite).
    # quickfix commands are cgetexpr, lgetexpr, lgrep, grep, etc.
    # exclude cadexppr also ([^c]*), otherwise g//caddexpr will open quickfix after the first match.
    # https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
    autocmd QuickFixCmdPost [^lc]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
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
    # :retab to change tab characters to match existing settings
    # :expandtab replaces tab to spaces
    # gitdiff by default uses 8 for tab width
    # Use <c-v><tab> to insert real tab character
    autocmd FileType c,cpp,java,vim,lua set softtabstop=4 shiftwidth=4 expandtab
    # Remove any trailing whitespace that is in the file
    autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
    # for competitive programming  (book by Antti Laaksonen); install gcc using homebrew
    # autocmd FileType cpp,c setlocal makeprg=g++\ -std=c++11\ -O2\ -Wall\ %\ -o\ %<
    #
augroup END

# testing
# augroup scope-quickfix-history
#     autocmd!
#     autocmd QuickFixCmdPost chistory cwindow
#     autocmd QuickFixCmdPost lhistory lwindow
#     autocmd QuickFixCmdPost clist cwindow
#     autocmd QuickFixCmdPost llist lwindow
# augroup END
