# For gcp cloud shell
# .profile is not sourced if .bash_profile exists
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html

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
if command -v /usr/bin/zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi
if [ ! -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    sudo apt install -y zsh-autosuggestions
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

set -o vi

# this should be the last thing in this file
# XXX: it takes a few minutes for zsh to appear in /etc/shells (list of valid shells)
# https://zsh.sourceforge.io/FAQ/zshfaq01.html#l7
# if [ -f /bin/zsh ]; then
#     exec /bin/zsh
# else
#     # zsh is not available yet through /etc/shells, so try reinstallign it.
#     sudo apt install -y zsh
#     [ -f /bin/zsh ] && exec /bin/zsh
# fi
