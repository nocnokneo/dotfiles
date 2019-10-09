# Enable Emacs/Readline interactive mode
# See: https://github.com/PowerShell/PSReadLine
If($Host.Name -eq 'ConsoleHost') {
    Import-Module PSReadline
    Set-PSReadLineOption -EditMode Emacs
}

