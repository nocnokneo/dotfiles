notetoself()
{
    case "$1" in
        -h,--help)
            echo <<EOF
Usage: notetoself [TIMESPEC]

Email a note to yourself (i.e. \$USER). Reads the note stdin. The first line
of the note will be used as the subject of the email.

The optional TIMESPEC argument specifies when the email should be sent. See
at(1) for valid formats. If not specified, the default is "now".
EOF
            ;;
        *)
            export body=$(</dev/stdin)
            export subject="[notetoself] $(echo "${body}" | head -n 1)"
            echo 'echo "${body}" | mail -s "${subject}" ${USER}' | at ${1:-now}
            ;;
    esac
}
