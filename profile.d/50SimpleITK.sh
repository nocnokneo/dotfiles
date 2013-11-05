# Support in SimpleITK for default Fiji installation of ImageJ
if [ -x /opt/Fiji.app/fiji-linux64 ]; then
    export SITK_SHOW_COMMAND=/opt/Fiji.app/fiji-linux64
fi
