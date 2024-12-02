#!/bin/zsh

##
# Named directories
#
# Create shortcuts for your favorite directories.
# Set these early, because it affects how dirs are displayed and printed.
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
# You can use this ~name anywhere you would specify a dir, not just with `cd`!
#
# XXX: ~/.zsh starts showing up as ~zsh (confusing)
hash -d zsh=$ZDOTDIR
hash -d vim=$HOME/.vim
hash -d help=$HOME/help
hash -d nvim=$HOME/.config/nvim
