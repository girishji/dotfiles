# For gcp cloud shell
# ~/.profile says .profile is not sourced if .bash_profile exists

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
    # include .bash_aliases
    if [ -f "$HOME/.bash_aliases" ]; then
        . "$HOME/.bash_aliases"
    fi
fi

# Customizations
if command -v fdfind &> /dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf $(which fdfind) "$HOME/.local/bin/fd"
fi
if command -v /usr/bin/zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if ! command -v pyright &> /dev/null; then
    npm install --global pyright
fi

if [ -d "$HOME/git/qmk_firmware" ] ; then
    pip install --user qmk
fi

if command -v /usr/bin/zsh &> /dev/null; then
    exec /usr/bin/zsh
fi
# [ -f /usr/bin/zsh ] && exec /usr/bin/zsh

set -o vi
