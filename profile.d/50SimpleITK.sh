# Support in SimpleITK for default Fiji installation of ImageJ
if [ -x /opt/Fiji.app/fiji-linux64 ]; then
    export SITK_SHOW_COMMAND=${HOME}/.local/opt/Fiji.app/ImageJ-linux64
fi
