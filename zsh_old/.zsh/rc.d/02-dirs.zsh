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

# This lets you change to any dir without having to type `cd`, that is, by just
# typing its name. Be warned, though: This can misfire if there exists an alias,
# function, builtin or command with the same name.
# In general, I would recommend you use only the following without `cd`:
#   ..  to go one dir up
#   ~   to go to your home dir
#   ~-2 to go to the 2nd mostly recently visited dir
#   /   to go to the root dir
setopt AUTO_CD
