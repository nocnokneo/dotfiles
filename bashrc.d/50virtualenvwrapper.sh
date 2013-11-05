# If virtualenvwrapper.sh is not if available, there's nothing to do
type virtualenvwrapper.sh &>/dev/null || return

# Enable virtualenvwrapper. Provides mkvirtualenv, workon, deactivate,
# rmvirtualenv, etc. See full list of commands:
# http://www.doughellmann.com/docs/virtualenvwrapper/command_ref.html
. virtualenvwrapper.sh

# Source the (terribly named) autoenv activation code (NOTE: overrides the
# `cd` builtin)
if type activate.sh &>/dev/null; then
    . activate.sh
fi

# The use_env call below is a reusable command to activate/create a new Python
# virtualenv, requiring only a single declarative line of code in your .env files.
# It only performs an action if the requested virtualenv is not the current one.
# Modified snippet from: https://github.com/kennethreitz/autoenv/wiki/Cookbook
use_env() {
  typeset venv
  venv="$1"
  if [[ "${VIRTUAL_ENV##*/}" != "$venv" ]]; then
    if workon | grep -q "$venv"; then
      workon "$venv"
    else
      echo -n "Create virtualenv $venv now? (Yn) "
      read answer
      if [[ "$answer" == "Y" ]]; then
        mkvirtualenv "$venv"
      fi
    fi
  fi
}
