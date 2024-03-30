#!/bin/zsh

##
# Commands, funtions and aliases
#
# Always set aliases _last,_ so they don't get used in function definitions.
#

# This lets you change to any dir without having to type `cd`, that is, by just
# typing its name. Be warned, though: This can misfire if there exists an alias,
# function, builtin or command with the same name.
# In general, I would recommend you use only the following without `cd`:
#   ..  to go one dir up
#   ~   to go to your home dir
#   ~-2 to go to the 2nd mostly recently visited dir
#   /   to go to the root dir
setopt AUTO_CD

# Type '-' to return to your previous dir.
alias -- -='cd -'
# '--' signifies the end of options. Otherwise, '-=...' would be interpreted as
# a flag.

# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=

# zmv lets you batch rename (or copy or link) files by using pattern matching.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv
autoload -Uz zmv
alias zmv='zmv -Mv'
alias zcp='zmv -Cv'
alias zln='zmv -Lv'
# Note that, unlike with Bash, you do not need to inform Zsh's completion system
# of your aliases. It will figure them out automatically.

# Set $PAGER if it hasn't been set yet. We need it below.
# `:` is a builtin command that does nothing. We use it here to stop Zsh from
# evaluating the value of our $expansion as a command.
: ${PAGER:=less}

# Associate file name .extensions with programs to open them.
# This lets you open a file just by typing its name and pressing enter.
# Note that the dot is implicit; `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s {log,out}='tail -F'
alias -s git='git clone'


# Use `< file` to quickly view the contents of any text file.
READNULLCMD=$PAGER  # Set the program to use for this.

# girish

# note: global aliases work even in the middle of command line. non-global ones work
# only at the beginning of a command.
alias -g H='| head'
alias -g L='| less -R'
alias -g AWK=$'| awk \'{print  cnt++,$3,$4}\'' # Ansi C quoting
alias -g SED=$'| sed \'/color/ s/red/green/g\''
alias -g X=$'| xargs -I {} echo {}'
alias -g T=' 2>&1 | tee tee.txt'
alias -g @noerr="2> /dev/null"
alias -g W=" | while read x; do ; done"
alias F="for x (**/*(.));do ;done"  # use *** to follow symlink

# find
# note:
#  - -name refers to last componenet of path
#  - when using glob chars like *, ?, use single quotes to escape shell interpretation
#  - cannot alias 'fi' since it is a reserved keyword, 'fg' is foreground cmd
alias ff="find . \( -name '*.zwc' -o -name '*.swp' -o -path '*/.git*' -o -path '*/plugged*' \) -prune -o -type f -print -follow"
alias fff="find . -name '*.c' -print -follow -exec grep --color -EHni xxx {} \;"

# git
alias ga='git add .; gitcommit '
alias gs='git status '
alias gc='git clone '
alias gp='git push'
alias gu='git pull --no-rebase'
alias gd='git diff'

alias ug='ug -j -R'  # smartcase and follow symlinks, --hidden for dot files
alias ugg='ug -j -R -Q'
alias uggg='ug -%% -j -w -R -Q' # google search with regex, see https://ugrep.com/
alias ag='ag --smart-case'

# grep
# note: ERE (extended regex) vs BRE (basic): ERE escapes +. ? etc. like vim's 'magic'
#       --color is --color=auto. It does not use color codes when pipe is used.
#       To see colors use grep --color=always foo | less -R
#       https://stackoverflow.com/questions/6565471/how-can-i-exclude-directories-from-grep-r
#       --exclude pattern -> Patterns are matched to the full path specified, not only to the filename component.
#       --include pattern -> can be specified after --exclude
#       --exclude-dir pattern -> If -R is specified, it excludes directories
#         matching the given filename pattern from the search.  Note that --exclude-dir
#         and --include-dir patterns are processed in the order given.
#         --exclude-dir is dir-name(s) and not pathname(s). directory names cannot contain '/'
#         Following doesn't work:
#         (NO) grep -r --exclude-dir={/var/cache,/var/lib}
#       --include-dir pattern -> just like --include
#       -F, --fixed-strings -> Interpret pattern as a set of fixed strings.
#       Note: above pattern is globs pattern, not pattern as in regex. So it
#       does not understand |. You can, however, get the same effect by
#       specifying --exclude-dir multiple times, one for each directory that
#       you want to exclude, or you can golf it shorter.
#       --exclude-dir={git,log,assets}
#       --exclude-dir={\*git,asset\*}
#
#       {} is brace expansion for command line flags.
#       % foocmd -u{rspamd,postfix}
#         Expands to: foocmd -urspamd -upostfix
#       % foocmd --unit={rspamd,postfix}
#         Expands to: foocmd --unit=rspamd --unit=postfix
#       If you want space instead of '=', use a backslash or quote:
#       % print -z foocmd --unit' '{rspamd,postfix}
#       % foocmd --unit rspamd --unit postfix
#       % print -z foocmd --unit\ {rspamd,postfix}
#       % foocmd --unit rspamd --unit postfix
#       note: does not work/expand if there is only one item inside {}. if you
#       put {item,} it expands to 'item' and '' (test with 'print -z' like above).
#
#       -i ignore case, -n include line number, -R recursive, -w word regex
#       as if surrounded by ‘[[:<:]]’ and ‘[[:>:]]’, see 'man re-format';
#       -l prints files with matches only; -S (macos only) follow symlinks
#       -I ignores binary files (prevents a info message getting printed)
#
alias gr="grep --color=always -RESIins --exclude={'*.zwc','*.swp','*.git*','*.dict'}"
alias -g G='| grep --color -iEI'

alias pipi='pip install --user '
alias lc='leetcode '
alias vim_='vim -Nu NONE -S <(cat <<EOF
    " vim:ts=4:ft=vim
    vim9script
    :set shortmess=I
EOF
)'

alias l1='ls -1' # one listing per line
alias l='ls'
alias ll='ls -l'
alias c='z'
alias ca='cat'
alias cl='clear'
alias diffw='diff -w'  # ignore white spaces

alias less='command less -R' # -R for interpreting Ansi color codes
alias le='less'
alias p3='python3'
alias rm='rm -i'
alias targ='tar -c --exclude-from=.gitignore -vzf'
alias t='python3 ~/git/t/t.py --task-dir ~/.local/share/todo --list tasks'
alias tt='tree'
alias formatjson='python3 -m json.tool'
alias jsonformat='python3 -m json.tool'

alias v='vim'
alias vd='vi -d'  # diff mode - pass 2 files
alias vr='vim -c "normal '\''0"'  # restore last opened buffer
alias viclean='vim --clean'

alias makedebug="make SHELL='sh -x'"

if is_mac; then
    alias ba='bat --style=plain' # without line numbers
    alias bc='bc -l'
    # note: use 'py' which is ipython+pyflyby
    # alias ip='ipython --no-confirm-exit --colors=Linux'
    alias ls='ls -FG' # aliases the command /usr/bin/ls
    alias x86="$env /usr/bin/arch -x86_64 /bin/zsh ---login"
    alias arm="$env /usr/bin/arch -arm64 /bin/zsh ---login"
    alias ibooks='cd /Users/gp/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents'
    alias obsidian='cd /Users/gp/Library/Mobile Documents/iCloud~md~obsidian/Documents'
    alias op='open'
    alias gssh='gcloud compute ssh --zone "us-central1-a" "n2dstd" --project "sandbox-403316" --ssh-flag="-ServerAliveInterval=30"'
    alias gscp='gcloud compute scp --recurse n2dstd:~/foo ~/bar'
    alias gstop='gcloud compute instances stop n2dstd'
    alias gcsh='gcloud cloud-shell ssh --authorize-session'
elif is_linux; then
    alias ls='ls --color=always' # auto/always/never
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

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias uuuuuu='cd ../../../../../..'
alias uuuuuuu='cd ../../../../../../..'
alias uuuuuuuu='cd ../../../../../../../..'
alias uuuuuuuuu='cd ../../../../../../../../..'
