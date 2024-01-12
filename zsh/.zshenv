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

is_macos() {
    [[ $(uname -s) == "Darwin" ]]
}

is_cloud_shell() {
    which gcloud > /dev/null && [[ $(gcloud config configurations list \
    --filter="is_active=true AND name ~ cloudshell" 2> /dev/null | wc -l) -ne 0 ]]
}

# suffix aliases (executing these file types will open app).
alias -s {lua,zshrc,cpp,c,cc,py,java,html,vim,md,markdown,scm,txt,vimrc}=vim
# alias -s git="git clone" # clone repo by simply pasting git url

# global aliases
# http://www.zzapper.co.uk/AliasTypesCheatSheet.php
alias -g G='| grep --color -iE'

# alias -g fg='find . -path "*/.*" -prune -o -exec {} \;'
alias -g H='| head '
alias -g L='| less '
# TAB Expand and then tweak as required
alias -g AWK=$'| awk \'{print  cnt++,$3,$4}\'' # Ansi C quoting
alias -g SED=$'| sed \'/color/ s/red/green/g\''
# alias -g X=$'| xargs -I {} -t echo {}' # -t will echo the command
alias -g X=$'| xargs -I {} echo {}'
alias -g T=' 2>&1 | tee tee.txt'

# cannot alias 'fi' since it is a reserved keyword, 'fg' is foreground cmd
alias -g find='find . -path pat_path -name pat_last_component -exec echo {} \;'
alias -g findd='find . \( -path "*/.*" -o -name cscope.out -o -name tags \) -prune -o -type f -print -exec grep --color -Ei x {} \;'
alias -g finddd='find . \( -path "*/.*" -o -name cscope.out -o -name tags \) -prune -o -type f -print'

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
alias pipi='pip install --user '
alias -g lc='leetcode '
# alias -g vim_='vim -Nu NONE -S <(cat <<EOF
#     " vim:ts=4:ft=vim
#     vim9script
# EOF
# )'
alias rg='rg --smart-case'
alias ag='ag --smart-case'

if is_macos; then
    alias b='bat'
    alias ba='bat --style=plain' # without line numbers
    alias bc='bc -l'
    alias em='emacs'
    # XXX: use 'py' which is ipython+pyflyby
    alias ip='ipython --no-confirm-exit --colors=Linux'
    alias ls='ls -FG' # aliases the command /usr/bin/ls
    alias nv='nvim'
else
    alias ls='ls --color=always' # auto/always/never
fi

# NOTE: ERE (extended regex) vs BRE (basic): ERE escapes +. ? etc. like vim's 'magic'
#       --color is --color=auto. It does not use color codes when pipe is used. To see colors use grep --color=always foo | less -R
alias gr1='command grep --color -E' # ERE instead of BRE
alias gr2='grep --color=always -E' # for 'less' command pipethrough
alias -g gr='grep --color=always -Ei' # ERE and case insensitive

alias l1='ls -1' # one listing per line
alias l='ls'
alias ll='ls -l'
alias c='z'
alias ca='cat'
alias ci='zi' # interactive z: list the directories by fzf and cd
alias cl='clear'
alias diffw='diff -w'  # ignore white spaces
alias f='builtin fg'
# alias fd='fd -c never' # no colors
alias gd='git diff'

alias less='command less -R' # -R for interpreting Ansi color codes
alias le='less'
alias p3='python3'
alias rm='rm -i'
alias targ='tar -c --exclude-from=.gitignore -vzf'
alias t='python3 ~/git/t/t.py --task-dir ~/.local/share/todo --list tasks'
alias tt='tree'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias uuuuuu='cd ../../../../../..'
alias uuuuuuu='cd ../../../../../../..'
alias uuuuuuuu='cd ../../../../../../../..'
alias uuuuuuuuu='cd ../../../../../../../../..'

alias v='vim'
alias vd='vi -d'  # diff mode - pass 2 files
alias vr='vim -c "normal '\''0"'  # restore last opened buffer
alias viclean='vim --clean'

alias makedebug="make SHELL='sh -x'"

unameout=$(uname -s)
if is_macos; then
    . "$HOME/.cargo/env"
    alias ibooks='cd /Users/gp/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents'
    alias obsidian='cd /Users/gp/Library/Mobile Documents/iCloud~md~obsidian/Documents'
    alias op='open'

    alias g gssh='gcloud compute ssh --zone "us-central1-a" "n2dstd" --project "sandbox-403316" --ssh-flag="-ServerAliveInterval=30"'
    alias -g gscp='gcloud compute scp --recurse n2dstd:~/foo ~/bar'
    # alias -g gscp='gcloud compute scp'
    alias gstop='gcloud compute instances stop n2dstd'
    alias gcsh='gcloud cloud-shell ssh --authorize-session'
else
    if [[ ! -d "$HOME/.config" ]]; then
        mkdir -p $HOME/.config
    fi
    if is_cloud_shell; then
        if [[ -f ~/bin/vim.appimage ]]; then
            alias vi='~/bin/vim.appimage'
            alias vim='~/bin/vim.appimage'
        fi
    fi
fi
