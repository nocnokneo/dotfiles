# Don't use public keys from ~/.ssh/authorized_keys. Can also add:
# -o PreferredAuthentications=keyboard-interactive
alias ssh-no-pubkey='ssh -o PubkeyAuthentication=no'
if [ -n "$BASH_COMPLETION" ]; then
    complete -F _ssh -o nospace ssh-no-pubkey
fi
