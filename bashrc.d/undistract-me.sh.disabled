# Copyright (c) 2008-2012 undistract-me developers. See LICENSE for details.
#
# Check for interactive bash and that we haven't already been sourced.
[ -z "$BASH_VERSION" -o -z "$PS1" -o -z "$DISPLAY" -o -n "$last_command_started_cache" ] && return

if [ -r /usr/share/undistract-me/long-running.bash ]; then
    . /usr/share/undistract-me/long-running.bash
    notify_when_long_running_commands_finish_install
fi
