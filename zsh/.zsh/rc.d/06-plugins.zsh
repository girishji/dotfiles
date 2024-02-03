##
# Plugins
#

# Add the plugins you want to use here.
# For more info on each plugin, visit its repo at github.com/<plugin>
# -a sets the variable's type to array.
local -a plugins=(
    marlonrichert/zsh-autocomplete      # Real-time type-ahead completion
    # marlonrichert/zsh-edit              # Better keyboard shortcuts
    # marlonrichert/zsh-hist              # Edit history from the command line.
    # marlonrichert/zcolors               # Colors for completions and Git
    zsh-users/zsh-autosuggestions       # Inline suggestions
    zsh-users/zsh-syntax-highlighting   # Command-line syntax highlighting
)

# The Zsh Autocomplete plugin sends *a lot* of characters to your terminal.
# This is fine locally on modern machines, but if you're working through a slow
# ssh connection, you might want to add a slight delay before the
# autocompletion kicks in:
#   zstyle ':autocomplete:*' min-delay 0.5  # seconds
#
# If your connection is VERY slow, then you might want to disable
# autocompletion completely and use only tab completion instead:
#   zstyle ':autocomplete:*' async no


# Speed up the first startup by cloning all plugins in parallel.
# This won't clone plugins that we already have.
znap clone $plugins

# Load each plugin, one at a time.
local p=
for p in $plugins; do
  znap source $p
done

# `znap eval <name> '<command>'` is like `eval "$( <command> )"` but with
# caching and compilation of <command>'s output, making it ~10 times faster.
# znap eval zcolors zcolors   # Extra init code needed for zcolors.

# Configure zoxide completion
eval "$(zoxide init zsh)"

# zsh-autosuggestions: offers suggestions as you type
if is_mac; then
    source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# Make PgDn accept suggestion; by default right-arrow accepts suggestion
bindkey '^[[6~' autosuggest-accept
# XXX: Setting fg color does not work properly. It does not repaint the screen
# after right-arrow completion.
# bg_color="${COLORFGBG:-0;-1}" # if not set, use default value of 0;-1 (fg;bg)
if [[ ${bg_color} == "0;15" ]]; then # light background
  typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# else
#   typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'
fi
