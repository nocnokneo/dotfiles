# Prepend the first Android NDK found to the system PATH
for d in /opt/android-ndk* /opt/ndk-bundle ${HOME}/Android/Sdk/ndk-bundle; do
    if [ -e ${d}/ndk-which ]; then
        case ":${PATH:-}:" in
            *:${d}:*) ;;
            *) PATH="${d}${PATH:+:$PATH}" ;;
        esac
        break
    fi
done
