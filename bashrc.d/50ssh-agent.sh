# Start ssh-agent if it is not already running (needed on most (all?)
# distros for non-graphical logins). Unlock keys with `ssh-add`.
#
# From: http://mah.everybody.org/docs/ssh#run-ssh-agent

# Only launch ssh-agent for interactive shells because it only makes sense in
# this scenario and because ssh-agent does not startup silently which breaks
# rsync.
case "$-" in
    *i*)
        SSH_AGENT=/usr/bin/ssh-agent
        SSH_AGENT_ARGS="-s"
        if [ -z "$SSH_AUTH_SOCK" -a -x "$SSH_AGENT" ]; then
            eval `$SSH_AGENT $SSH_AGENT_ARGS`
            # Kill ssh-agent when the shell dies
            trap "kill $SSH_AGENT_PID" 0
        fi
        ;;
esac
