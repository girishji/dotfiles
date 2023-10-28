
alias ga='git add .; gitcommit '
alias gs='git status '
alias gc='git clone '
alias gp='git push'
alias gu='git pull --no-rebase'
alias pipi='pip install --user '
alias lc='leetcode '
alias rgi='rg -i ' # case insensitive

alias b='bat'
alias ba='bat --style=plain' # without line numbers
alias bc='bc -l'
alias c='z'
alias ca='cat'
alias ci='zi' # interactive z: list the directories by fzf and cd
alias cl='clear'
alias diffw='diff -w'  # ignore white spaces
alias em='emacs'
alias f='builtin fg'
alias fd='fd -c never'
alias gcsh='gcloud cloud-shell ssh'
alias gd='git diff'
# NOTE: use "ag" or "rg" command instead of grep
alias gr='grep -Ei'  # extended regex and case insensitive
alias grc='grep -E'  # extended regex and case sensitive
alias grep='command grep --color' # aliases /usr/bin/grep
alias grr='grep -Ei -R --exclude-dir=.git --exclude-dir=.github'  # extended regex and recursivly search subdirs (like rgrep)
#
# XXX: use 'py' which is ipython+pyflyby
alias ip='ipython --no-confirm-exit --colors=Linux'
alias ls='ls -FG' # aliases the command /usr/bin/ls
alias l1='ls -1' # one listing per line
alias l='ls'
alias ll='ls -l'
alias le='command less -R' # -R for interpreting color codes
alias p3='python3'
alias rm='rm -i'
alias targ='tar -c --exclude-from=.gitignore -vzf'
alias t='python3 ~/Projects/t/t.py --task-dir ~/.local/share/todo --list tasks'
alias nv='nvim'
alias nvc='nvim --clean'
alias nvr='nvim -c "normal '\''0"'  # restore last opened buffer ('0 mark has last cursor location)
alias tt='tree'
alias v='~/bin/vim.appimage'
alias vi='~/bin/vim.appimage'
alias vim='~/bin/vim.appimage'
alias vd='vi -d'  # diff mode - pass 2 files
alias vr='vim -c "normal '\''0"'  # restore last opened buffer
alias viclean='vim --clean'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias uuuuuu='cd ../../../../../..'
alias uuuuuuu='cd ../../../../../../..'
alias uuuuuuuu='cd ../../../../../../../..'
alias uuuuuuuuu='cd ../../../../../../../../..'

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi
