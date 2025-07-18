# For gcp cloud shell

alias ga='git add .; gitcommit '
alias gs='git status '
alias gc='git clone '
alias gp='git push'
alias gu='git pull --no-rebase'
alias gd='git diff'
alias gb='git branch'
alias gch='git checkout'
alias gl='git log --oneline --decorate --graph --no-merges origin/master..HEAD'
alias gl2='git log --oneline --decorate --graph --all'
alias gd='git diff'
alias gd2='git diff origin/master '
alias gdv='git difftool -t vimdiff'

alias b='bat'
alias ba='bat --style=plain' # without line numbers
alias bc='bc -l'
# alias c='z'
alias c='cd'
alias ca='cat'
alias ci='zi' # interactive z: list the directories by fzf and cd
alias cl='clear'
alias diffw='diff -w'  # ignore white spaces
alias em='emacs'
alias gr='grep -Ei'  # extended regex and case insensitive
alias grc='grep -E'  # extended regex and case sensitive
alias grep='command grep --color' # aliases /usr/bin/grep
alias gg='grep -Ei -R --exclude-dir=.git --exclude-dir=.github'  # extended regex and recursivly search subdirs (like rgrep)
#
# XXX: use 'py' which is ipython+pyflyby
alias ip='ipython --no-confirm-exit --colors=Linux'
alias ls='ls --color=auto'
alias l1='ls -1' # one listing per line
alias l='ls'
alias ll='ls -l'
alias le='command less -R' # -R for interpreting color codes
alias p3='python3'
alias rm='rm -i'
alias targ='tar -c --exclude-from=.gitignore -vzf'
alias nv='nvim'
alias nvc='nvim --clean'
alias nvr='nvim -c "normal '\''0"'  # restore last opened buffer ('0 mark has last cursor location)
alias tt='tree'
alias vd='vi -d'  # diff mode - pass 2 files
alias vr='vim -c "normal '\''0"'  # restore last opened buffer
alias viclean='vim --clean'
if [ -f "$HOME/git/vim/dist/bin/vim" ]; then
    alias v="$HOME/git/vim/dist/bin/vim"
    alias vi="$HOME/git/vim/dist/bin/vim"
    alias vim="$HOME/git/vim/dist/bin/vim"
fi
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias uuuuuu='cd ../../../../../..'
alias uuuuuuu='cd ../../../../../../..'
alias uuuuuuuu='cd ../../../../../../../..'
alias uuuuuuuuu='cd ../../../../../../../../..'

# vim: ts=4 shiftwidth=4 sts=4 expandtab
