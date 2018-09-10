# If we `gem install --user-install xxx` we want any executables from the gem
# to be in our path for the ruby in our system PATH
# https://guides.rubygems.org/faqs/#user-install
if which ruby >/dev/null && which gem >/dev/null; then
    export GEM_HOME="$(ruby -r rubygems -e 'puts Gem.user_dir')"
    PATH="${GEM_HOME}/bin:${PATH}"
fi
