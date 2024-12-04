#!/bin/zsh

##
# Always set aliases _last,_ so they don't get used in function definitions.
#
#

typeset -Ag cursor_offset

# Type '-' to return to your previous dir.
alias -- -='cd -'
# '--' signifies the end of options. Otherwise, '-=...' would be interpreted as
# a flag.

# These aliases enable us to paste example code into the terminal without the
# shell complaining about the pasted prompt symbol.
alias %= \$=

# zmv lets you batch rename (or copy or link) files by using pattern matching.
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#index-zmv
# Type 'zmv' to see uage.
autoload -Uz zmv
alias zmv='zmv -v'   # Move files
alias zcp='zmv -Cv'  # Copy files
alias zln='zmv -Lv'  # Link files
alias zmmv='noglob zmv -Wv'  # Type 'zsh' for explanation
# Note that, unlike with Bash, you do not need to inform Zsh's completion system
# of your aliases. It will figure them out automatically.

# Associate file name .extensions with programs to open them.
# This lets you open a file just by typing its name and pressing enter.
# Note that the dot is implicit; `gz` below stands for files ending in .gz
alias -s {css,gradle,html,js,json,md,patch,properties,txt,xml,yml}=$PAGER
alias -s gz='gzip -l'
alias -s git='git clone'

# note: global aliases work even in the middle of command line. non-global ones work
# only at the beginning of line.
alias -g H='| head'
alias -g L='| less -R'
alias -g SED=$'| sed \'/pat/ s///g\''
cursor_offset["SED"]=12
alias -g X=$'| xargs -I {} echo {}'
cursor_offset["X"]=8
alias -g T='2>&1 | tee .txt'
cursor_offset["T"]=5
alias -g @noerr="2> /dev/null"
alias -g W="| while read x; do ;done"
cursor_offset["W"]=6
alias F="for x (**/*(.));do ;done"  # use *** to follow symlink
cursor_offset["F"]=6

# find
# note:
#  - -name refers to last componenet of path
#  - when using glob chars like *, ?, use single quotes to escape shell interpretation
#  - cannot alias 'fi' since it is a reserved keyword, 'fg' is foreground cmd
alias fF='find -E . ! \( -regex ".*\.(zwc|swp|git|zsh_.*)" -prune \) -type f -follow -name "*"'
cursor_offset["fF"]=3
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
# foo*~*.bak = all matches for foo* except those matching *.bak (think as 'foo*' AND '~*.bak')
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
alias ff='ls **/*~(*.zwc|*.swp|build/*)'
cursor_offset["ff"]=24

# git
alias ga='git add .; gitcommit'
alias gs='git status '
alias gc='git clone '
alias gp='git push'
alias gu='git pull --no-rebase'
alias gd='git diff'

# alias ug='ug -j -R'  # smartcase and follow symlinks, --hidden for dot files
# alias ugg='ug -j -R -Q'
# alias uggg='ug -%% -j -w -R -Q' # google search with regex, see https://ugrep.com/
# alias ag='ag --smart-case'

# grep
#
# Note: ERE (extended regex) vs BRE (basic): ERE escapes +, ., ?, |, etc. like vim's 'magic'
# egrep/ERE is like '\v' magic in Vim.
#   grep    '\(hello\|goodbye) cruel world+'
#   egrep   '(hello|goodbye) cruel world\+'
#
# Note: Do not put "" around {} when using with --exclude. {} will bypass the
# shell, and passed to grep command. There should be at least 2 entries inside
# {}. Escape '*' and '.' using backslash, or enclose them in quotes.
# Also, pattern should be inside "" or ''. Otherwise special characters needs
# to be escaped.
#    Ex: ggrep -REIHSins --exclude-dir={.git,zsh_\*} --exclude={\.\*,tags} "" .
#        ggrep -REIHSins --exclude-dir={.git,"zsh_*"} --exclude={".*",tags} "" .
#
#  Difference b/w --exclude and --exclude-dir:
#   --exclude is used to ignore files that match a certain pattern. It operates only on files, not directories. For instance:
#            grep --exclude="*.log" "pattern" -r .
#      This command excludes all .log files from the search, but it does not
#      prevent grep from searching inside directories (including hidden
#      directories) that might contain those files.
#    --exclude-dir specifically excludes directories. --exclude-dir is
#    specifically designed to prevent grep from descending into directories
#    whose names match the given pattern. For example:
#            grep --exclude-dir="node_modules" "pattern" -r .
#    This command will skip the entire node_modules directory and all of its
#    contents during the recursive search. This is particularly useful if you
#    have directories with numerous files or heavy content that you want to skip
#    entirely.
#
#    Why use --exclude-dir when --exclude could suffice?
#    Efficiency:
#    --exclude-dir is more efficient when you want to skip entire directories
#    rather than just filtering individual files. grep will not even try to
#    enter those directories, saving time and resources.
#    Granularity:
#    --exclude allows for fine-grained control over individual files, whereas
#    --exclude-dir skips directories as a whole. If your goal is to skip entire
#    directories, --exclude-dir is the more straightforward and performant
#    option.
#    Example:
#    If you want to exclude all .log files and also prevent grep from searching in the node_modules directory, you would use:
#            grep --exclude="*.log" --exclude-dir="node_modules" "pattern" -r .
#    In this case, both options work together: --exclude ensures individual .log
#    files are not searched, while --exclude-dir skips the entire node_modules
#    directory.
#
#  DO NOT USE BSD MACOS grep. IT EXCLUDES DIRECTORIES WHEN YOU SPECIFY
#  --exclude. USE GNU 'ggrep'.
#
#       --color is --color=auto. It does not use color codes when pipe is used.
#       To see colors use grep --color=always foo | less -R
#       https://stackoverflow.com/questions/6565471/how-can-i-exclude-directories-from-grep-r
#       --include pattern
#       --include-dir pattern
#       -F, --fixed-strings -> Interpret pattern as a set of fixed strings.
#
# 'sh -c' (POSIX) does not include {} expansion.
# cannot use --exclude-dir={foo,bar} using /bin/sh
#
# from :h zshtips.md
# grep -i "$1" **/*.{js,php,css}~(libs|temp|tmp|test)/* # exclude directories from grep *N* EXTENDED_GLOB required
#
# CAUTION: Avoid **/* and ***/* as shell complains 'too many paths to expand' when searching a large directory.

alias gr="ggrep -REIins --exclude={'*.zwc','*.swp','*.git*'} \"\""
cursor_offset["gr"]=2

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
# alias gr='ggrep -EIins "" ***/*'  # no need for '-R' since '***' takes care of recursion (and symlink following)
# cursor_offset["gr"]=8
alias -g G='| ggrep --color -iEI'

# alias pipi='pip install --user '
alias pipi='pip install'

# alias lc='leetcode'

alias vim_='vim -Nu NONE -S <(cat <<EOF
    vim9script
    :set shortmess=I

    # vim: ft=vim sw=4 sts=4 et
EOF
)'

alias c='z'
alias ca='cat'
alias cl='clear'
alias le='less'
alias p3='python3'
alias rm='rm -i'
alias diffw='diff -w'  # ignore white spaces
alias less='command less -R' # -R for interpreting Ansi color codes
alias targ='tar -c --exclude-from=.gitignore -vzf'
alias t='python3 ~/git/t/t.py --task-dir ~/.local/share/todo --list tasks'
alias tt='tree'
alias formatjson='python3 -m json.tool'
alias jsonformat='python3 -m json.tool'
alias vimdiff='vimdiff -o'

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

# gcc for competitive programming
alias gcc_='g++-14 -std=c++23 -Wall -Wextra -Wconversion -DONLINE_JUDGE -O2 -lstdc++exp -o /tmp/a.out  && /tmp/a.out'
cursor_offset["gcc_"]=15
# clang with c++23
alias clang++_='clang++ -include"$HOME/.clang-repl-incl.h" -std=c++23 -stdlib=libc++ -fexperimental-library -o /tmp/a.out  && /tmp/a.out'
cursor_offset["clang++_"]=15

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
        # alias ls='gls --color=always -F' # auto/always/never
        alias ls='ls -FG' # aliases the command /usr/bin/ls
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

# XXX: Aliases should not be expanded when autocomplete has completed a word. 'zle
# _expand_alias' has a bug(?) where it another item from autocomplete menu is
# used for replacement.

# Do not expand following aliases (create an array of them)
# NOTE: there are 3 types of variables: local to script/function (use 'local'
# keyword), those visible in terminal (do not use 'local') but not available to
# other tools, and environment variables (use 'export' keyword, and these
# variables are available in terminal as well as accessible from other tools)
MY_ALIAS_EXPAND_BLACKLIST=(t ls rm)

# Make <space> expand alias (other option is to use completion mechanism (Tab))
my_expand_alias() {
    # for (#m) see backreferences in https://zsh.sourceforge.io/Guide/zshguide05.html
    # for '%%' see 'conditional substitutions' in https://zsh.sourceforge.io/Guide/zshguide05.html
    # https://github.com/willghatch/zsh-snippets/blob/master/snippets.plugin.zsh
    # https://scriptingosx.com/2019/11/associative-arrays-in-zsh/
    local MATCH
    : ${LBUFFER%%(#m)[.\-+:|_a-zA-Z0-9]#}
    local blacklist_pattern="^(${(j:|:)MY_ALIAS_EXPAND_BLACKLIST})$"
    if ! [[ $MATCH =~ $blacklist_pattern ]]; then
        local word_before_cursor=${LBUFFER##* }
        if [[ -n "$word_before_cursor" ]] && alias "$word_before_cursor" &>/dev/null; then
            zle _expand_alias
            zle self-insert
            zle backward-char -n ${cursor_offset["$MATCH"]:-0}
            return
        fi
    fi
    # LBUFFER+=" "  # alternative: self-insert widget inserts typed char into cmdline
    zle self-insert
}

# Set up the widget
zle -N my_expand_alias

# Bind the widget to run after completion
# 'main' defaults of viins or emacs (https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html)
# bindkey -M main ' ' my_expand_alias
bindkey -M main ' ' my_expand_alias

# Store the history number before completion
HISTNO_BEFORE_COMPLETION=$HISTNO

# To avoid alias expansion press <control-space> or <alt-space>
# https://github.com/MenkeTechnologies/zsh-expand/blob/master/zsh-expand.plugin.zsh
my_do_not_expand_alias() {
    LBUFFER+=" "
}
zle -N my_do_not_expand_alias
bindkey -M main "^@" my_do_not_expand_alias
bindkey -M main "^[ " my_do_not_expand_alias
