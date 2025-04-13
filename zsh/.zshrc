##
# Put things here that are specific to installation and OS.
#

##
# Env Vars
#
() {
    # -U ensures each entry in these is unique (that is, discards duplicates).
    export -U PATH path FPATH fpath MANPATH manpath
    export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.

    # Setup to use appropriate brew based on arch value and set
    # HOMEBREW_PREFIX, PATH and other global vars
    if [ "$(arch)" = "arm64" ]; then
        eval $(/opt/homebrew/bin/brew shellenv);
    else
        eval $(/usr/local/bin/brew shellenv);
    fi

    if command -v brew > /dev/null; then # Verify whether brew exists in the user's PATH.
        # Add dirs containing completion functions to your $fpath and they will be
        # picked up automatically when the completion system is initialized.
        # Here, we add it to the end of $fpath, so that we use brew's completions
        # only for those commands that zsh doesn't already know how to complete.
        fpath+=(
            $HOMEBREW_PREFIX/share/zsh/site-functions
        )
    fi

    # nvim plugins should separated by arch, since treesitter parser executable
    # depends on arch
    export XDG_DATA_HOME="${HOME}/.local/share/"$(arch)

    export EDITOR=vim
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-19.jdk/Contents/Home

    # export OPENAI_API_KEY=sk-E...

    # Use a 8-bit color theme for bat
    export BAT_THEME="ansi"
    export BAT_STYLE="numbers,changes,grid,header"

    # Make 'pip3 install --user xxx' packages available
    # export PATH=$PATH:$(python3 -m site --user-base)/bin

    # Add cursor location in %
    export MANPAGER='less -s -M +Gg'

    # leetcode-api
    # if [[ -f "$HOME/.cargo/env" ]]; then
    #     # Rust
    #     . "$HOME/.cargo/env"
    #     # [[ -f "$Home/.cargo/env" ]] && . "$HOME/.cargo/env"
    #     # leetcode (installed through cargo)
    #     eval "$(leetcode completions)"
    # fi

    # if python virtual env is present, activate it
    # [[ -f "$HOME/.venv/bin/activate" ]] && source "$HOME/.venv/bin/activate"

    # # The next line updates PATH for the Google Cloud SDK.
    # gcpath="$HOME/.local/opt/google-cloud-sdk"
    # if [ -f "$gcpath/path.zsh.inc" ]; then . "$gcpath/path.zsh.inc"; fi
    # # The next line enables shell command completion for gcloud.
    # if [ -f "$gcpath/completion.zsh.inc" ]; then . "$gcpath/completion.zsh.inc"; fi
    # unset gcpath

    # $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
    # Modifying one will also modify the other.
    path=(
        /home/linuxbrew/.linuxbrew/bin(N)   # (N): null if file doesn't exist
        $path
        ~/bin(N)
        ~/.local/bin(N)
        $HOMEBREW_PREFIX/opt/llvm/bin${PATH+:$PATH} # clangd and llvm on M1 Mac with brew
    )

    # Functions in $fpath are autoloaded.
    fpath=(
        ~/.zsh/functions(N)
        $fpath
        ~/.local/share/zsh/site-functions(N)
    )

}

##
# Key Bindings
#
() {
    # In Macos Terminal app, <BS> does not delete non-inserted character.
    # https://vi.stackexchange.com/questions/31671/set-o-vi-in-zsh-backspace-doesnt-delete-non-inserted-characters
    # Following is applicable if you ticked "BS sends ^H" option in Termina.app preferences:
    # bindkey "^H" backward-delete-char
    # If you didn't choose the above option (default). <BS> sends <Delete> (aka "^?") character.
    bindkey | grep \"\^\?\" > /dev/null || bindkey "^?" backward-delete-char
}

##
# Plugins
#
() {
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
}

##
# History
#
() {
    HISTFILE=${XDG_DATA_HOME:=~/.local/share}/zsh/history

    # Just in case: If the parent directory doesn't exist, create it.
    [[ -d $HISTFILE:h ]] ||
        mkdir -p $HISTFILE:h

    # Max number of entries to keep in history file.
    SAVEHIST=$(( 10 * 1000 ))       # Use multiplication for readability.

    # Max number of history entries to keep in memory.
    HISTSIZE=$(( 1.2 * SAVEHIST ))  # Zsh recommended value

    # Use modern file-locking mechanisms, for better safety & performance.
    setopt HIST_FCNTL_LOCK

    # Keep only the most recent copy of each duplicate entry in history.
    setopt HIST_IGNORE_ALL_DUPS

    # Auto-sync history between concurrent sessions.
    setopt SHARE_HISTORY
}

##
# Aliases
#
() {
    alias ba='bat --style=plain' # without line numbers
    alias bc='bc -l'
    if which gls >/dev/null ; then
        # TIP: brew install coreutils
        # All the gnu commands will be prefixed with 'g'. Can do 'man gls'.
        # Note: https://apple.stackexchange.com/questions/432386/use-ls-colors-not-lscolors-on-mac-os
        #
        # See ~/bin/ls
        # Example: export LS_COLORS="di=1;34:ln=1;36:ex=1;32:*.txt=1;33"
        #
        if [[ ${bg_color} != "0;15" ]]; then # dark background
            # export LS_COLORS='di=1:ln=3:ex=3'  # 1=bold, 3=italic, see ~/help/ls
            export LS_COLORS='di=0;34:ln=0;35:ex=0;33'  # see help/ls
        fi
        alias ls='gls --color=always -F' # auto/always/never
    else
        alias ls='ls -FG' # aliases the command /usr/bin/ls
    fi
    alias x86="$env /usr/bin/arch -x86_64 /bin/zsh ---login"
    alias arm="$env /usr/bin/arch -arm64 /bin/zsh ---login"
    alias ibooks='cd /Users/gp/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents'
    alias obsidian='cd /Users/gp/Library/Mobile Documents/iCloud~md~obsidian/Documents'
    alias op='open'
    # -fexperimental-library is needed for std::ranges
    alias cr='clang-repl --Xcc=-include"$HOME/.clang-repl-incl.h" --Xcc=-std=c++23 --Xcc=-stdlib=libc++ --Xcc=-fexperimental-library'
    alias clang_repl='clang-repl --Xcc=-include"$HOME/.clang-repl-incl.h" --Xcc=-std=c++23 --Xcc=-stdlib=libc++ --Xcc=-fexperimental-library'

    alias gsh='gcloud compute ssh --zone "us-central1-c" "vimfix" --project "sandbox-403316" --ssh-flag="-ServerAliveInterval=30"'
    alias gscp='gcloud compute scp --zone "us-central1-c" --project "sandbox-403316" from vimfix:~/to'
    alias gstop='gcloud compute instances stop vimfix'
    # alias gcsh='gcloud cloud-shell ssh --authorize-session'
    alias vi=vim
}

## Source customizations.
# Strings in "double quotes" are what is in some languages called "template
# strings": They allow the use of $expansions inside, which are then
# substituted with the parameters' values.
# Strings in 'single quotes', on the other hand, are literal strings. They
# always evaluate to the literal characters you see on your screen.
if [ -f "$HOME/.zsh.common" ]; then
    . $HOME/.zsh.common
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gp/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gp/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gp/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gp/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
