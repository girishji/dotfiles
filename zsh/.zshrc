############################################################

setopt vi

setopt histignorealldups sharehistory

############################################################
## Completions
# https://zsh.sourceforge.io/Guide/zshguide06.html

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# From gcloud default file
# zstyle ':completion:*' auto-description 'specify: %d'
# # zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' completer _expand _expand_alias _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# # zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

## OLD ##
# prioritize files with suffix aliases ahead of commands
#   for completing first word typed
zstyle ':completion:*:complete:-command-:*:*' tag-order \
  suffix-aliases

# Tab expand aliases (only global aliases)
zstyle ':completion:*' completer _expand_alias _complete _ignored

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# provide verbose completion information
zstyle ':completion:*'                 verbose true

############################################################
# Prompt
if is_macos; then
    # PROMPT="%B%F{3}[%f%F{207}$(arch)%f%F{3}]%f%b "
    PROMPT="%F{3}[%f%F{1}$(arch)%f%F{3}]%f "
    PROMPT+='%40<..<%~%<< ' # shortened path
    autoload -Uz vcs_info
    precmd_vcs_info() { vcs_info }
    precmd_functions+=( precmd_vcs_info )
    setopt prompt_subst
    PROMPT+=\$vcs_info_msg_0_
    zstyle ':vcs_info:git:*' formats '%F{5}[%f%F{2}%b%f%F{5}]%f '
    zstyle ':vcs_info:*' enable git
    PROMPT+='%# ' # changes to '#' when root
    # PROMPT='$ '
    RPROMPT='%F{1}%(?..%? :( )%f' # display return code of cmd only when not 0
    # NOTE: Using single quotes will delay evaluation of functions until prompt is computed.
    #   Double quotes forces the evaluation of function when you set the PROMPT variable.
else
    PROMPT="%F{3}%BGCLOUD%b%f: "
    PROMPT+='%F{87}%40<..<%~%<<%f ' # shortened path
    autoload -Uz vcs_info
    precmd_vcs_info() { vcs_info }
    precmd_functions+=( precmd_vcs_info )
    setopt prompt_subst
    PROMPT+=\$vcs_info_msg_0_
    zstyle ':vcs_info:git:*' formats '%F{5}[%f%F{2}%b%f%F{5}]%f '
    zstyle ':vcs_info:*' enable git
    if is_cloud_shell; then
        # PROMPT+="%F{207}(%f${DEVSHELL_PROJECT_ID:-cloudshell}%F{207})%f "
        if [[ -n "$DEVSHELL_PROJECT_ID" ]]; then
            # PROMPT+="%F{207}(%f${DEVSHELL_PROJECT_ID:-cloudshell}%F{207})%f "
            PROMPT+="%F{207}(%fcloudshell:${DEVSHELL_PROJECT_ID}%F{207})%f "
        else
            PROMPT+="%F{207}(%fcloudshell%F{207})%f "
        fi
    else # cloud vm
        PROMPT+="%F{207}(%f%m%F{207})%f "
    fi
    PROMPT+='%# ' # changes to '#' when root

    RPROMPT='%F{1}%(?..%? :( )%f' # display return code of cmd only when not 0
    # NOTE: Using single quotes will delay evaluation of functions until prompt is computed.
    #   Double quotes forces the evaluation of function when you set the PROMPT variable.
fi

############################################################
## Exports

if is_macos; then
    # Setup to use appropriate brew based on arch value and set
    # HOMEBREW_PREFIX, PATH and other global vars
    if [ "$(arch)" = "arm64" ]; then
        eval $(/opt/homebrew/bin/brew shellenv);
    else
        eval $(/usr/local/bin/brew shellenv);
    fi
    # nvim plugins should separated by arch, since treesitter parser executable
    # depends on arch
    export XDG_DATA_HOME="${HOME}/.local/share/"$(arch)

    # For picking up clangd and llvm on M1 Mac with brew
    export PATH="$HOMEBREW_PREFIX/opt/llvm/bin${PATH+:$PATH}"

    export EDITOR=vim
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-19.jdk/Contents/Home

    # export OPENAI_API_KEY=sk-E...

    # Use a 8-bit color theme for bat
    export BAT_THEME="ansi"
    export BAT_STYLE="numbers,changes,grid,header"

    # Make 'pip3 install --user xxx' packages available
    export PATH=$PATH:$(python3 -m site --user-base)/bin
    export PATH="$PATH:$HOME/bin:$HOME/.local/bin";

    # Add cursor location in %
    export MANPAGER='less -s -M +Gg'
fi

############################################################
## Colors

# https://superuser.com/questions/290500/zsh-completion-colors-and-os-x
# export LSCOLORS=Exfxcxdxbxegedabagacad; # make dir color bold

############################################################
# Keybindings

# This should be bound by default, but for some reason it is vanishing often
# https://zsh.sourceforge.io/Guide/zshguide06.html
# pass arg 2 (Esc 2 C-xh, in emacs mode) for verbose output
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Bindable-Commands
bindkey -M viins '^Xh' _complete_help

# Edit line in vim with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey -M viins '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line

# C-y to yank previous word and print
yank_previous_word_and_print () {
    zle copy-prev-word
    zle end-of-line
}
zle -N yank_previous_word_and_print
bindkey -M viins "\C-y" yank_previous_word_and_print
bindkey -M vicmd "\C-y" yank_previous_word_and_print

# Change cursor shape for different vi modes.
# https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52
zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

# ctrl-w (and ctrl-backspace in iterm) kills word backward (backward-kill-word)
#
# alt-backspace kill a word or filename up to '/'
#https://unix.stackexchange.com/questions/258656/how-can-i-have-two-keystrokes-to-delete-to-either-a-slash-or-a-word-in-zsh
backward-kill-a-unit-in-path () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-a-unit-in-path
bindkey '^[^?' backward-kill-a-unit-in-path

## alt arrow keys
# bindkey "^[^[[D" backward-word
# bindkey "^[^[[C" forward-word
bindkey "^[^[[D" emacs-backward-word
bindkey "^[^[[C" emacs-forward-word

## while loop
append_while () {
    text_to_add=" | while read x; do ; done"
    RBUFFER=${RBUFFER}${text_to_add}
    zle end-of-line
    zle backward-word -n 2
}
zle -N append_while
bindkey "\C-xw" append_while

## for loop
for_loop () {
    text_to_add="for x  ;do ;done"
    RBUFFER=${RBUFFER}${text_to_add}
    zle end-of-line
    zle backward-word -n 2
}
zle -N for_loop
bindkey "\C-xf" for_loop

for_loop2 () {
    # use *** to follow symlink
    RBUFFER="${RBUFFER}for x (**/*(.));do ;done"
    zle end-of-line
    zle backward-word
}
zle -N for_loop2
bindkey "\C-x\C-f" for_loop2

# tee command to redirect to file
tee_cmd () {
    zle end-of-line
    text_to_add=" 2>&1|tee .out"
    RBUFFER=${RBUFFER}${text_to_add}
    zle end-of-line
    zle backward-word
}
zle -N tee_cmd
bindkey "\C-xt" tee_cmd

## add a piped grep at the end
append_piped_grep() {
  RBUFFER="${RBUFFER} | egrep -i -n ''"
  zle end-of-line
  zle backward-char -n 1
}
zle -N append_piped_grep # add a widget
bindkey "\C-g" append_piped_grep

## add a piped xargs with grep at the end
append_piped_xargs_grep() {
  RBUFFER="${RBUFFER} | xargs -0 -r egrep -i -n ''"
  zle end-of-line
  zle backward-char -n 1
}
zle -N append_piped_xargs_grep # add a widget
bindkey "\C-x\C-g" append_piped_xargs_grep

## find and grep
## alternative:
##   rg
##   grr foobar // grr is aliased to grep recursive
##   https://github.com/sharkdp/fd#how-to-use
##   l1 ***/*(.) C-xC-g // C-g adds grep at the end, C-xC-g adds xargs grep
find_grep () {
    text_to_add="fd . -t f --follow -e egrep -i -n ''"
    # text_to_add="find . -follow -type f -print0 |xargs -0 -r egrep -i -n ''"
    # -print0 and -0 are needed since some filenames can have quotes in them
    # text_to_add="for x (***/*(.)); do grep -n -H '' \$x; done"
    RBUFFER=${RBUFFER}${text_to_add}
    zle end-of-line
    # zle backward-word -n 2
    zle backward-char -n 1
}
# create a zle widget, which will invoke the function, and bind the key
zle -N find_grep
bindkey "\C-xg" find_grep

# Insert awk
insert_awk () {
    text_to_add="|awk ''"
    RBUFFER=${RBUFFER}${text_to_add}
    zle end-of-line
    zle backward-char
}
zle -N insert_awk
bindkey "\C-xa" insert_awk

# Insert sed
insert_sed () {
    text_to_add="|sed -e 's///'"
    RBUFFER=${RBUFFER}${text_to_add}
    zle end-of-line
    zle backward-char
    zle backward-char
    zle backward-char
}
zle -N insert_sed
bindkey "\C-xs" insert_sed

############################################################
# Functions
# do 'which' to get definition
# If Tab does not complete the command, it is because zsh has not
#   loaded all ways to find the command. Execute it once and then
#   it will show up in suggestions.

if is_macos; then

    # rsync dirs A and B, A being the source
    # https://stackoverflow.com/questions/13713101/rsync-exclude-according-to-gitignore-hgignore-svnignore-like-filter-c
    # https://unix.stackexchange.com/questions/203846/how-to-sync-two-folders-with-command-line-tools
    rsyncdir() {
      if [[ $# -ne 2 ]]; then
        echo "Usage: rsyncdir {srcdir} {destdir}"
        return -1
      fi
      rsync --delete-after --filter=":e- .gitignore" --filter "- .git/" -v -a "${1}/" "${2}" # slash after first arg is important
    }

    # fzf: https://thevaluable.dev/practical-guide-fzf-example/
    # When no input is given to fzf (meaning w/o pipe) it will use fd instead of find
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    # XXX: fd ignores files from .gitignore
    # export FZF_ALT_C_COMMAND='fd --type d -H' # -H --hidden to show files hidden by .gitignore;
    # KEYBINDINGS: tab, shift-tab, etc. see 'man fzf'
    export MY_FZF_KEYBINDINGS="tab:up,shift-tab:down,alt-up:prev-history,alt-down:next-history,alt-shift-up:toggle-out,alt-shift-down:toggle-in,ctrl-p:preview-page-up,ctrl-n:preview-page-down,ctrl-/:change-preview-window(hidden|)"
    bg_color="${COLORFGBG:-0;-1}" # if not set, use default value of 0;-1 (fg;bg)
    if [[ ${bg_color} == "0;15" ]]; then # light background
      export MY_FZF_COLORS="hl:10,bg+:7,fg+:-1:underline"
    else
      export MY_FZF_COLORS="bg+:${bg_color#*;},fg+:underline,hl:5,hl+:4,pointer:4,gutter:-1"
    fi
    my_fzf_history="${HOME}/.local/share/fzf-cmd-history"
    # XXX: Do not export FZF_DEFAULT_OPTS, it interfers with fzf inside Vim

    # fzf keybindings (CTRL-T, CTRL-R, ALT-C) <- run /usr/local/opt/fzf/install first
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

    # Search *file name* in curdir and browse contents using pager (bat) (press <CR>)
    # Alt-pgup/down to scroll preview window
    # ff() {
    #   fzf --bind 'enter:execute(bat -f --paging=always {})' \
    #     --preview 'bat -f {}' \
    #     --bind "${MY_FZF_KEYBINDINGS}" \
    #     --color "${MY_FZF_COLORS}" \
    #     # --bind 'ctrl-/:change-preview-window(hidden|)'
    # }

    # Search for a *keyword* in curdir and browse files.
    # Alt-pgup/down to scroll preview window
    # Switch between Ripgrep launcher mode (CTRL-R) and fzf filtering mode (CTRL-F)
    # https://github.com/junegunn/fzf/blob/master/ADVANCED.md#ripgrep-integration
    # fr() {
    #   rm -f /tmp/rg-fzf-{r,f}
    #   RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    #   INITIAL_QUERY="${*:-}"
    #   FZF_DEFAULT_COMMAND_SAVED="$FZF_DEFAULT_COMMAND"
    #   FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
    #     fzf --ansi \
    #     --color "hl:-1:underline,hl+:-1:underline:reverse" \
    #     --no-bold \
    #     --color "${MY_FZF_COLORS}" \
    #     --disabled --query "$INITIAL_QUERY" \
    #     --history "${my_fzf_history}" \
    #     --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    #     --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
    #     --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
    #     --bind "start:unbind(ctrl-r)" \
    #     --prompt '1. ripgrep> ' \
    #     --delimiter : \
    #     --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱' \
    #     --preview 'bat --color=always {1} --highlight-line {2}' \
    #     --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    #     --bind 'enter:become(FZF_DEFAULT_COMMAND=$FZF_DEFAULT_COMMAND_SAVED vim {1} +{2})' \
    #     --bind "${MY_FZF_KEYBINDINGS}"
    # }

fi

# Upgrade top level pip packages (their dependencies will also get updated to appropriate versions)
pipupdate() {
  pipdeptree -f --warn silence | grep -E '^[a-zA-Z0-9\-]+' | grep -v '@' | sed 's/=.*//' | xargs -n1 pip install --user -U
  pip check
}

venvcreate() {
  (($#1)) && python -m venv $1/.venv || python -m venv ./.venv
}

venv() {
  (($#1)) && source $1/.venv/bin/activate || source ./.venv/bin/activate
}

venvdeactivate() {
  deactivate
}

############################################################
## Plugins

# Configure zoxide completion
eval "$(zoxide init zsh)"

# zsh-autosuggestions
if is_macos; then
    # leetcode-api
    # Rust
    source "$HOME/.cargo/env"
    # leetcode (installed through cargo)
    eval "$(leetcode completions)"
    ## Offers suggestions as you type
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# Make PgDn accept suggestion; by default right-arrow accepts suggestion
bindkey '^[[6~' autosuggest-accept
# XXX: Setting fg color does not work properly. It does not repaint the screen
# after right-arrow completion.
# bg_color="${COLORFGBG:-0;-1}" # if not set, use default value of 0;-1 (fg;bg)
if [[ ${bg_color} == "0;15" ]]; then # light background
  typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# else
#   typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'
fi

############################################################

if is_macos; then
    # The next line updates PATH for the Google Cloud SDK.
    if [ -f '/Users/gp/.local/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gp/.local/opt/google-cloud-sdk/path.zsh.inc'; fi
    # The next line enables shell command completion for gcloud.
    if [ -f '/Users/gp/.local/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gp/.local/opt/google-cloud-sdk/completion.zsh.inc'; fi
fi

