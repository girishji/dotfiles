# zsh only readis .zprofile when called as login shell, unlike bash which reads
# .bash_profile or .profile

if command -v /usr/bin/zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
