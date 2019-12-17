# Enable Emacs/Readline interactive mode
# See: https://github.com/PowerShell/PSReadLine
If($Host.Name -eq 'ConsoleHost') {
    Import-Module PSReadline
    Set-PSReadLineOption -EditMode Emacs
}

# Ref: https://www.windows-commandline.com/reboot-computer-from-command-line/
function reboot { wmic os where Primary=TRUE reboot }
