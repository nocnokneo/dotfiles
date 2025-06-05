# Start ssh-agent if it is not already running (needed on most (all?)
# distros for non-graphical logins). Unlock keys with `ssh-add`.
#
# From: http://mah.everybody.org/docs/ssh#run-ssh-agent

_ensure_ssh_agent() {
    if [[ -z "$SSH_AUTH_SOCK" ]] && which ssh-agent >&/dev/null; then
        eval `ssh-agent -s`
        # Kill ssh-agent when the shell dies
        trap "kill $SSH_AGENT_PID" 0
    fi
}

# Only launch ssh-agent for interactive shells because it only makes sense in
# this scenario and because ssh-agent does not startup silently which breaks
# rsync.
if [[ $- == *i* ]]; then
    _ensure_ssh_agent
fi
