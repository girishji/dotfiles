#!/bin/zsh

# Functions in this file are loaded at startup.
# To lazy load functions, put them (one per file, name matching file name)
# inside a directory included in fpath (like ../functions/), and then call
# autoload. autoload declares a function to be loaded on demand from your
# $fpath.

# Upgrade top level pip packages (their dependencies will also get updated to appropriate versions)
pipupdate() {
    pipdeptree -f --warn silence | grep -E '^[a-zA-Z0-9\-]+' | grep -v '@' | sed 's/=.*//' | xargs -n1 pip install --user -U
    pip check
}

venvcreate() {
    (($#1)) && python -m venv $1/.venv || python -m venv ./.venv
}

venvactivate() {
    (($#1)) && source $1/.venv/bin/activate || source ./.venv/bin/activate
}

venvdeactivate() {
    deactivate
}

venv() {
    venvactivate
}

