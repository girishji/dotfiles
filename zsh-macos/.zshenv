# zshrc.grml overwrites these aliases that are duplicated there 
#
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# Vim does not source .zshrc since it starts a non-interactive shell during `:!`
# command.
# Basically, zsh always sources ~/.zshenv. Interactive shells source ~/.zshrc,
# and login shells source ~/.zprofile and ~/.zlogin. Thus, an interactive login
# shell sources ~/.zshenv ~/.zprofile ~/.zlogin ~/.zlogin, and a noninteractive,
# nonlogin shell like the one vim uses to run commands only sources ~/.zshenv.
# See https://unix.stackexchange.com/questions/113462/how-can-i-make-shell-aliases-available-when-shelling-out-from-vim

# suffix aliases (executing these file types will open app).
alias -s {lua,zshrc,cpp,c,cc,py,java,html,vim,md,markdown,scm,txt,vimrc}=vim
# alias -s git="git clone" # clone repo by simply pasting git url

# global aliases
# http://www.zzapper.co.uk/AliasTypesCheatSheet.php
alias -g G='| grep -i'
alias -g GV='| grep -ivaE' # negative grep pipe
alias -g F='| fzf'
alias -g H='| head '
alias -g M='| less '
# TAB Expand and then tweak as required
alias -g AWK=$'| awk \'{print  cnt++,$3,$4}\'' # Ansi C quoting
alias -g SED=$'| sed \'/color/ s/red/green/g\''
# alias -g X=$'| xargs -I {} -t echo {}' # -t will echo the command
alias -g X=$'| xargs -I {} echo {}'
alias -g T=' 2>&1 | tee tee.txt'
alias -g fdf='fd -tf -tl' # search file, ex: fdf foo
alias -g fdd='fd -td' # search dir, ex: fdd foo
alias -g fdx='fd -tx' # search executable
alias -g fde='fd -te' # search for empty dirs and files
# alias -g ga='git diff; git add .; gitcommit '
alias -g ga='git add .; gitcommit '
alias -g gs='git status '
alias gc='git clone '
alias -g gp='git push'
alias -g gu='git pull --no-rebase'
alias -g pipi='pip install --user '
alias -g lc='leetcode '
alias -g vims='vim -Nu NONE -S <(cat <<EOF
    " vim:ts=4:ft=vim
    vim9script
EOF
)'
alias rg='rg --smart-case'
alias ag='ag --smart-case'

# other aliases
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
# alias fd='fd -c never' # no colors
alias gcsh='gcloud cloud-shell ssh --authorize-session'
alias gd='git diff'
# NOTE: use "ag" or "rg" command instead of grep
alias grep='command grep --color'
alias grep2='grep --color=always'
alias gr='grep -Ei'  # extended regex and case insensitive
alias grc='grep -E'  # extended regex and case sensitive
alias gr2='grep2 -Ei'  # extended regex and case insensitive
alias grc2='grep2 -E'  # extended regex and case sensitive
# --color is --color=auto. It does not use color codes when pipe is used. To see colors use grep --color=always foo | less -R
alias grr='grep -Ei -R --exclude-dir=.git --exclude-dir=.github'  # extended regex and recursivly search subdirs (like rgrep)
#
alias ibooks='cd /Users/gp/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents'
# XXX: use 'py' which is ipython+pyflyby
alias ip='ipython --no-confirm-exit --colors=Linux'
alias ls='ls -FG' # aliases the command /usr/bin/ls
alias l1='ls -1' # one listing per line
alias l='ls'
alias ll='ls -l'
alias less='command less -R' # -R for interpreting Ansi color codes
alias le='less'
alias obsidian='cd /Users/gp/Library/Mobile Documents/iCloud~md~obsidian/Documents' 
alias op='open'
alias op='open'  # open foo.rtf will open in textedit
alias p3='python3'
alias rm='rm -i'
alias targ='tar -c --exclude-from=.gitignore -vzf'
alias t='python3 ~/git/t/t.py --task-dir ~/.local/share/todo --list tasks'
alias nv='nvim'
alias nvc='nvim --clean'
alias nvr='nvim -c "normal '\''0"'  # restore last opened buffer ('0 mark has last cursor location)
alias tt='tree'
alias v='vim'
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

# alias ssh1='gcloud compute ssh --zone "us-central1-f" "vm-fast" --project "finanse" --ssh-flag="-ServerAliveInterval=30"'
# alias gscp='gcloud compute scp'
# alias gscpr='gcloud compute scp --recurse'
. "$HOME/.cargo/env"
