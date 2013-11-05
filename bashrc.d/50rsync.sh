# rsync common options alias that still works with bash_completion
alias rsync-sensible='rsync --recursive --links --perms --times --sparse'
if [ -n "$BASH_COMPLETION" ]; then
    complete -F _rsync -o nospace rsync-sensible
fi
