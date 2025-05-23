#!/bin/zsh

##
# Environment variables
#

# -U ensures each entry in these is unique (that is, discards duplicates).
export -U PATH path FPATH fpath MANPATH manpath
export -UT INFOPATH infopath  # -T creates a "tied" pair; see below.

# $PATH and $path (and also $FPATH and $fpath, etc.) are "tied" to each other.
# Modifying one will also modify the other.
# Note that each value in an array is expanded separately. Thus, we can use ~
# for $HOME in each $path entry.
#
# 1. path=(...)
# In shells like zsh, path is an array that specifies directories to search for executable files.
# Modifying the path changes how the shell looks for commands.
# 2. /home/linuxbrew/.linuxbrew/bin(N)
# The (N) qualifier is specific to zsh.
# (N) means "null glob," which makes the shell skip this path silently if the directory does not exist or is empty.

path=(
    /home/linuxbrew/.linuxbrew/bin(N)   # (N): null if file doesn't exist
    $path
    ~/.local/bin
)

# Add your functions to your $fpath, so you can autoload them.
fpath=(
    $ZDOTDIR/functions
    $fpath
    ~/.local/share/zsh/site-functions
)

if is_mac; then
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

    # For picking up clangd and llvm on M1 Mac with brew
    export PATH="$HOMEBREW_PREFIX/opt/llvm/bin${PATH+:$PATH}"

    export EDITOR=vim
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-19.jdk/Contents/Home

    # export OPENAI_API_KEY=sk-E...

    # Use a 8-bit color theme for bat
    export BAT_THEME="ansi"
    export BAT_STYLE="numbers,changes,grid,header"

    # Make 'pip3 install --user xxx' packages available
    export PATH=$PATH:$(python3 -m site --user-base)/bin

    # Enhance PATH
    export PATH="$PATH:$HOME/bin:$HOME/.local/bin";

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

    # The next line updates PATH for the Google Cloud SDK.
    gcpath="$HOME/.local/opt/google-cloud-sdk"
    if [ -f "$gcpath/path.zsh.inc" ]; then . "$gcpath/path.zsh.inc"; fi
    # The next line enables shell command completion for gcloud.
    if [ -f "$gcpath/completion.zsh.inc" ]; then . "$gcpath/completion.zsh.inc"; fi
    unset gcpath
fi
