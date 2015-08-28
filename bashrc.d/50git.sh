if ! type git &>/dev/null; then
    return
fi

if ! type __git_ps1 &>/dev/null; then
    . ~/.dotfiles/bashrc.d/git-prompt.sh
fi

hg_ps1() {
    hg prompt "{ on {branch}}{ at {bookmark}}{status}" 2> /dev/null
}

if type __git_ps1 &>/dev/null; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM="auto"
    export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[0;36m\]$(hg_ps1)$(__git_ps1 " (%s)")\[\033[01;34m\] \$\[\033[00m\] '
fi

function git-rev-number()
{
    if [[ $1 == "" ]]; then
        echo "usage: git-rev-number <commit>"
        return 1
    fi
    number=`git rev-list --reverse HEAD | grep -n $1 | cut -d: -f1`
    if [[ $number == "" ]]; then
        echo "commit not found"
        return 1
    else
        echo $number
    fi
    return 0
}
