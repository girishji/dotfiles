#!/bin/zsh

##
# Key bindings
#
# zsh-autocomplete and zsh-edit add many useful keybindings. See each of their
# respective docs for the full list:
# https://github.com/marlonrichert/zsh-autocomplete/blob/main/README.md#key-bindings
# https://github.com/marlonrichert/zsh-edit/blob/main/README.md#key-bindings
#

# Enable the use of Ctrl-Q and Ctrl-S for keyboard shortcuts.
unsetopt FLOW_CONTROL

# Alt-Q
# - On the main prompt: Push aside your current command line, so you can type a
#   new one. The old command line is re-inserted when you press Alt-G or
#   automatically on the next command line.
# - On the continuation prompt: Move all entered lines to the main prompt, so
#   you can edit the previous lines.
bindkey '^[q' push-line-or-edit

# Alt-H: Get help on your current command.
() {
  unalias $1 2> /dev/null   # Remove the default.

  # Load the more advanced version.
  # -R resolves the function immediately, so we can access the source dir.
  autoload -RUz $1

  # Load $functions_source, an associative array (a.k.a. dictionary, hash table
  # or map) that maps each function to its source file.
  zmodload -F zsh/parameter p:functions_source

  # Lazy-load all the run-help-* helper functions from the same dir.
  autoload -Uz $functions_source[$1]-*~*.zwc  # Exclude .zwc files.
} run-help

# Alt-V: Show the next key combo's terminal code and state what it does.
bindkey '^[v' describe-key-briefly

# Alt-W: Type a widget name and press Enter to see the keys bound to it.
# Type part of a widget name and press Enter for autocompletion.
bindkey '^[w' where-is

# Alt-Shift-S: Prefix the current or previous command line with `sudo`.
() {
  bindkey '^[S' $1  # Bind Alt-Shift-S to the widget below.
  zle -N $1         # Create a widget that calls the function below.
  $1() {            # Create the function.
    # If the command line is empty or just whitespace, then first load the
    # previous line.
    [[ $BUFFER == [[:space:]]# ]] &&
        zle .up-history

    # $LBUFFER is the part of the command line that's left of the cursor. This
    # way, we preserve the cursor's position.
    LBUFFER="sudo $LBUFFER"
  }
} .sudo

# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

# Edit line in vim with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey -M viins '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line

# Add Text Objects
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/
# Add text objects for quotes or brackets: to do something like da" (to delete
# a quoted substring) or ci( (to change inside parenthesis).
# select-quoted is a widget from user contribution to zsh (man zshcontrib)
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done
# We loop through the two keymaps viopp (Vi OPERATOR-PENDING mode) and visual (Vi VISUAL mode).
# We loop through a whole bunch of signs we want to consider as quotes (or brackets), and we add to each of them the prefix i or a (for inside and around, respectively).
# We use the bindkey command to bind these new text-objects to both keymaps.

# https://github.com/marlonrichert/zsh-autocomplete?tab=readme-ov-file#configuration
# Make Tab go straight to the menu and cycle there
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# Make Enter submit the command line straight from the menu
bindkey -M menuselect '\r' .accept-line
# Limit number of lines shows:
#   Autocompletion
zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 3 )) )'
#   Override history search.
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
#   History menu.
zstyle ':autocomplete:history-search-backward:*' list-lines 256
# Show history menu on ctrl-R/S
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
