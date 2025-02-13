#!/bin/zsh

##
# Prompt theme
#

# Reduce startup time by making the left side of the primary prompt visible
# *immediately.*
#
# giri: following will source prompt_launchpad_setup
# znap prompt launchpad
#
# brew install pure

autoload -U promptinit; promptinit
prompt pure

zstyle ':prompt:pure:*' color -1
zstyle ':prompt:pure:git:*' color 248
zstyle :prompt:pure:virtualenv color 248
# znap prompt girishji/pure

# `znap prompt` can autoload our prompt function, because in 04-env.zsh, we
# added its parent dir to our $fpath.
