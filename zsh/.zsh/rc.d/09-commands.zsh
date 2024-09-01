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

# Load zprof so that shell startup can be profiled.
# See https://www.bigbinary.com/blog/zsh-profiling
zmodload zsh/zprof

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
# alias ff="find . \( -name '*.zwc' -o -name '*.swp' -o -path '*/.git*' -o -path '*/plugged*' \) -prune -o -type f -follow -name '*'"
# alias ffg="find . -name '*.c' -print -follow -exec grep --color -EHni xxx {} \;"
#
# alternative:
# A very useful feature (of zsh) is the fancy globbing. The characters are a
# bit hard to remember but extremely convenient (as in, it's often faster to
# look them up than to write the equivalent find command).
#
# from :h zshtips.md
# ls **/*       # list everything in the tree
# ls **/*foo*   # list files <*foo*> wherever in the heirarchy
# foo*~*.bak = all matches for foo* except those matching *.bak (think as 'foo*' and '~*.bak')
# ls -lt  **/*.(php|css|js)(.om[1,20]) # list 20 newest web files anywhere in directory hierarchy (very useful) *N*
# ls -lt **/*.{js,php,css}~(libs|temp|tmp|test)/* # exclude directories from grep, EXTENDED_GLOB required
# ls **/*~*/.git/*  # ignore all git subdirectories
# ls -lt **/*~*vssver.scc  # excluding vssver.scc (see next)
# ls -lt **/^vssver.scc    #  excluding vssver.scc (simpler)
# ls -lt **/^(vssver.scc|*.ini) # excluding vssver and any *.ini
# extra:
# ls *(.)              # list just regular files
# ls -d *(/)           # list just directories
# ls ^*.(css|php)(.)   # list all but css & php
# vi **/main.php       # where ever it is in hierarchy
# foo*~*.bak = all matches for foo* except those matching *.bak
# also:
# foo*(.) = only regular files matching foo*
# foo*(/) = only directories matching foo*
# dir/**/foo* = foo* in the directory dir and all its subdirectories, recursively
#
# Add your pattern as in 'ls **/*<pat>...'. excludes files *.zwc, *.swp and dir plugged.
alias ff='ls **/*~(*.zwc|*.swp|plugged/*)'
alias lss='ls **/*~(*.zwc|*.swp|plugged/*)'


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
# from :h zshtips.md
# grep -i "$1" **/*.{js,php,css}~(libs|temp|tmp|test)/* # exclude directories from grep *N* EXTENDED_GLOB required

# alias gr="grep --color=always -RESIins --exclude={'*.zwc','*.swp','*.git*','*.dict'}"
#
# alternative:
#
# See comments under 'find' above, and also :h zshtips.md
# grep -i "$1" */*.php~libs/*~temp/*~test/* # exclude directories lib,temp,test from grep 'setopt EXTENDED_GLOB' required
# grep -i "$1" **/*.{js,php,css}~(libs|temp|tmp|test)/* # exclude directories from grep, EXTENDED_GLOB required
# grep excluding certain directories
# grep -i somestr **/*.(js|php|css) | grep -Ev 'libs/|temp/|test/'
# grep -i somestr **/*.(js|php|css)~libs/*~temp/*~test/*
# grep -i somestr **/*.(js|php|css)~(libs|temp|test)/*
# grep, dont use egrep, grep -E is better
# single quotes stop the shell, " quotes allow shell interaction
# grep 'host' **/(*.cfm~(ctpigeonbot|env).cfm)
# grep -i 'host' **/(*.cfm~(ctpigeonbot|env).cfm)~*((#s)|/)junk*/*(.)
# egrep -i "^ *mail\(" **/*.php
# grep "^ *mail\(" **/*.php~*junk*/*  #find all calls to mail, ignoring junk directories
# # grep '.' dot matches one character
# grep b.g file    # match bag big bog but not boog
# # grep * matches 0 , 1 or many of previous character
# grep "b*g" file # matches g or bg or bbbbg
# # grep '.*' matches a string
# grep "b.*g" file # matches bg bag bhhg bqqqqqg etc
# # grep break character is \
# grep 'hello\.gif' file
# grep "cat\|dog" file matches lines containing the word "cat" or the word "dog"
# grep "I am a \(cat\|dog\)" matches lines containing the string "I am a cat" or the string "I am a dog"
# grep "Fred\(eric\)\? Smith" file   # grep fred or frederic
alias gr='grep -EIins "f" **/*'
alias -g G='| grep --color -iEI'

# alias pipi='pip install --user '
alias pipi='pip install '

alias lc='leetcode '

alias vim_='vim -Nu NONE -S <(cat <<EOF
    " vim:ts=4:ft=vim
    vim9script
    :set shortmess=I
EOF
)'

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

# TIP: could use 'py' which is ipython+pyflyby (if installed through pipx, and ipython injected into it)
alias ip='ipython'

alias v='vim'
alias vd='vi -d'  # diff mode - pass 2 files
# alias vr='vim -c "normal '\''0"'  # restore last opened buffer
alias viclean='vim --clean'
alias nv='nvim'
alias nvi='nvim'

alias makedebug="make SHELL='sh -x'"

# There is also a venvactivate()
# Use 'deactivate' to undo
alias activate='source .venv/bin/activate'

if is_mac; then
    alias ba='bat --style=plain' # without line numbers
    alias bc='bc -l'
    if which gls >/dev/null ; then
        # TIP: brew install coreutils
        # All the gnu commands will be prefixed with 'g'. Can do 'man gls'.
        # Note: https://apple.stackexchange.com/questions/432386/use-ls-colors-not-lscolors-on-mac-os
        # export LS_COLORS='di=1:ln=3:ex=4'
        if [[ ${bg_color} != "0;15" ]]; then # dark background
            export LS_COLORS='di=1:ln=3:ex=3'
        fi
        alias ls='gls --color=always -F' # auto/always/never
    else
        alias ls='ls -FG' # aliases the command /usr/bin/ls
    fi
    alias l='ls'
    alias ll='ls -l'
    alias x86="$env /usr/bin/arch -x86_64 /bin/zsh ---login"
    alias arm="$env /usr/bin/arch -arm64 /bin/zsh ---login"
    alias ibooks='cd /Users/gp/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents'
    alias obsidian='cd /Users/gp/Library/Mobile Documents/iCloud~md~obsidian/Documents'
    alias op='open'
    # -fexperimental-library is needed for std::ranges
    alias cr='clang-repl --Xcc=-include"$HOME/.clang-repl-incl.h" --Xcc=-std=c++23 --Xcc=-stdlib=libc++ --Xcc=-fexperimental-library'
    # alias gssh='gcloud compute ssh --zone "us-central1-a" "n2dstd" --project "sandbox-403316" --ssh-flag="-ServerAliveInterval=30"'
    # alias gscp='gcloud compute scp --recurse n2dstd:~/foo ~/bar'
    # alias gstop='gcloud compute instances stop n2dstd'
    # alias gcsh='gcloud cloud-shell ssh --authorize-session'
elif is_linux; then
    export LS_COLORS='di=1:ln=3'
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
