# zsh only readis .zprofile when called as login shell, unlike bash which reads
# .bash_profile or .profile

if command -v fdfind &> /dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf $(which fdfind) "$HOME/.local/bin/fd"
fi

if command -v /usr/bin/zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
