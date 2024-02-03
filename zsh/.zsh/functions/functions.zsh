# Upgrade top level pip packages (their dependencies will also get updated to appropriate versions)
pipupdate() {
  pipdeptree -f --warn silence | grep -E '^[a-zA-Z0-9\-]+' | grep -v '@' | sed 's/=.*//' | xargs -n1 pip install --user -U
  pip check
}

venvcreate() {
  (($#1)) && python -m venv $1/.venv || python -m venv ./.venv
}

venv() {
  (($#1)) && source $1/.venv/bin/activate || source ./.venv/bin/activate
}

venvdeactivate() {
  deactivate
}
