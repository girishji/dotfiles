# Tips

: <<'END_COMMENT'

fzf:
- Use arrow keys or C-[jk] or C-[pn] to select from filtered window
- preview window: ctrl-p/n bound to page-up/down; Shift-[up/down] to scroll
- C-t to bring up files. Since java/c/md files are suffix aliased to nvim, you
    can start nvim by typing these files directly into the prompt
- alt-c for directories
- ctrl-r for history

# list all keymaps (viins is vi insert mode, vicmd is cmd mode, etc)
bindkey -l
# list all bindings
bindkey -M vicmd
# man zshzle // has descriptions of all actions (widgets according to zsh) you can bind to

zle is zsh line editor. movement and text modifying commands are in
https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Modifying-Text

Completion functions for commands (like pip, git, etc) are stored in files with
names beginning with an underscore _, and these files should be placed in a
directory after adding this directory to the $fpath variable.

END_COMMENT

############################################################

setopt vi

############################################################
## Completions
# https://zsh.sourceforge.io/Guide/zshguide06.html

# Initialize completion system
autoload -U compinit && compinit

# Autocompletion prioritize files with suffix aliases ahead of commands
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
## Exports

# nvim plugins should separated by arch, since treesitter parser executable
# depends on arch
export XDG_DATA_HOME="${HOME}/.local/share/"$(arch)

# For picking up clangd and llvm on M1 Mac with brew
export PATH="$HOMEBREW_PREFIX/opt/llvm/bin${PATH+:$PATH}"

export EDITOR=vim

# Make 'pip3 install --user xxx' packages available
export PATH=$PATH:$(python3 -m site --user-base)/bin
export PATH="$PATH:$HOME/bin:$HOME/.local/bin";

# Add cursor location in %
export MANPAGER='less -s -M +Gg'

###########################################################
# Prompt

PROMPT="%B%F{3}[%f%F{207}$(arch)%f%F{3}]%f%b "
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

############################################################
## Colors

# https://superuser.com/questions/290500/zsh-completion-colors-and-os-x
# export LSCOLORS=Exfxcxdxbxegedabagacad; # make dir color bold

############################################################
## Aliases

# Aliases are in ~/.zshenv

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
function zle-keymap-select {
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

## Offers suggestions as you type
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Make PgDn accept suggestion; by default right-arrow accepts suggestion
bindkey '^[[6~' autosuggest-accept
# XXX: Setting fg color does not work properly. It does not repaint the screen
# after right-arrow completion.
# bg_color="${COLORFGBG:-0;-1}" # if not set, use default value of 0;-1 (fg;bg)
# if [[ ${bg_color} == "0;15" ]]; then # light background
#   typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
# else
#   typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'
# fi

############################################################
