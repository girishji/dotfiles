#!/bin/zsh

##
# Plugin manager
#

# To upgrade all plugins installed through znap run: 'znap pull'
# https://github.com/marlonrichert/zsh-snap

local znap=~/.local/share/zsh-plugins/zsh-snap/znap.zsh

# Auto-install Znap if it's not there yet.
if ! [[ -r $znap ]]; then   # Check if the file exists and can be read.
  mkdir -p ~git
  git -C ~git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
fi

. $znap   # Load Znap.
