# Runtime threshold, in seconds, that determines if a command is considered
# long-running and should trigger a command complete notification (default is
# 10)
LONG_RUNNING_COMMAND_TIMEOUT=15

# Passed to `grep -vE`. If unset, all commands running longer than
# $LONG_RUNNING_COMMAND_TIMEOUT will trigger a notification
LONG_RUNNING_COMMAND_FILTER="^ *(sudo *)?(emacs|gedit|git|less|man|octave|ssh|vim)"
