# Start ssh-agent if it is not already running or connection info is lost.
# From: https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials#_using-ssh-keys

if [ -z "$SSH_AUTH_SOCK" ]; then
   # Define a standard, ephemeral location for the environment file
   AGENT_ENV_FILE="${XDG_RUNTIME_DIR:-$HOME/.cache}/ssh-agent.env"

   # Check for a currently running instance of the agent owned by YOUR user
   RUNNING_AGENT=$(pgrep -u "$USER" ssh-agent | wc -l)

   # Launch a new agent if none are running OR if the environment file is missing
   if [ "$RUNNING_AGENT" = "0" ] || [ ! -f "$AGENT_ENV_FILE" ]; then
        # Clean up any orphaned agents we no longer have the socket for
        pkill -u "$USER" ssh-agent 2>/dev/null

        # Launch a new instance and save the output
        ssh-agent -s > "$AGENT_ENV_FILE"
   fi

   # Load the variables and add the key
   if [ -f "$AGENT_ENV_FILE" ]; then
       eval $(cat "$AGENT_ENV_FILE") > /dev/null
       ssh-add 2> /dev/null
   fi
fi
