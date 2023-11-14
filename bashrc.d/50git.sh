if ! type git &>/dev/null; then
    return
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
