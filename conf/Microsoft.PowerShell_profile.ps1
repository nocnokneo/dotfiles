If($Host.Name -eq 'ConsoleHost') {
    Import-Module PSReadline
    Set-PSReadLineOption -EditMode Emacs
}

