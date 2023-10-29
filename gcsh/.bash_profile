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
        source "$HOME/.bash_aliases"
    fi
fi

# Needed customizations
if ! command -v fdfind &> /dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf $(which fdfind) "$HOME/.local/bin/fd"
fi
if ! command -v zoxide &> /dev/null; then
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
