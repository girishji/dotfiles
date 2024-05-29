#!/bin/zsh

## When autocompleting, type '/' to dig into the directory. '<tab>' is reserved for
#  choosing options within the same level.

##
# template: https://github.com/marlonrichert/zsh-launchpad.git
#

# Note: The shebang #!/bin/zsh is strictly necessary for executable scripts
# only, but without it, you might not always get correct syntax highlighting
# when viewing the code.

# This file, .zshenv, is the first file sourced by zsh for EACH shell, whether
# it's interactive or not. This includes non-interactive sub-shells! So, put as
# little in this file as possible, to avoid performance impact.

# Zsh reads these files in the following order:
# $ZDOTDIR/.zshenv
# $ZDOTDIR/.zprofile
# $ZDOTDIR/.zshrc
# $ZDOTDIR/.zlogin
# $ZDOTDIR/.zlogout

# $ZDOTDIR is set to $HOME by default.

# Tell zsh where to look for our dotfiles.
# By default, Zsh will look for dotfiles in $HOME (and find this file), but
# once $ZDOTDIR is defined, it will start looking in that dir instead.
# ${X:=Y} specifies a default value Y to use for parameter X, if X has not been
# set or is null. This will actually create X, if necessary, and assign the
# value to it.
# To set a default value that is returned *without* setting X, use ${X:-Y}
# As in other shells, ~ expands to $HOME _at the beginning of a value only._
# ZDOTDIR=${XDG_CONFIG_HOME:=~/.config}/zsh
ZDOTDIR=$HOME/.zsh
