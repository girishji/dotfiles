#!/bin/zsh

is_mac()     { [[ $OSTYPE == darwin*   ]] }
is_linux()   { [[ $OSTYPE == linux-gnu ]] }
has_brew() { [[ -n ${commands[brew]}    ]] }
has_apt()  { [[ -n ${commands[apt-get]} ]] }
has_yum()  { [[ -n ${commands[yum]}     ]] }
is_cloud_shell() {
    which gcloud > /dev/null && [[ $(gcloud config configurations list \
    --filter="is_active=true AND name ~ cloudshell" 2> /dev/null | wc -l) -ne 0 ]]
}

# The construct below is what Zsh calls an anonymous function; most other
# languages would call this a lambda or scope function. It gets called right
# away with the arguments provided and is then discarded.
# Here, it enables us to use scoped variables in our dotfiles.
#
# $@ expands to all the arguments that were passed to the current context (in
# this case, to `zsh` itself).
# "Double quotes" ensures that empty arguments '' are preserved.
# It's a good practice to pass "$@" by default. You'd be surprised at all the
# bugs you avoid this way.
() {
  # `local` sets the variable's scope to this function and its descendendants.
  # local gitdir=~/.local/share/zsh-plugins  # where to keep repos and plugins

  # Load all of the files in rc.d that start with <number>- and end in `.zsh`.
  # (n) sorts the results in numerical order.
  #  <->  is an open-ended range. It matches any non-negative integer.
  # <1->  matches any integer >= 1.
  #  <-9> matches any integer <= 9.
  # <1-9> matches any integer that's >= 1 and <= 9.
  # See https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Operators
  # These files are sourced in the numeric order of their names.
  local file=
  for file in $ZDOTDIR/rc.d/<->-*.zsh(n); do
    . $file   # `.` is like `source`, but doesn't search your $path.
  done
} "$@"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gp/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gp/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gp/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gp/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
