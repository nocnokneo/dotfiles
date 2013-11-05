# Add tools and platform-tools directories to the system PATH if they exist
# (and are not already in the system PATH)
for toolpath in ~/adt-bundle-linux-x86_64/sdk/{platform-,}tools; do
    if [ -d $toolpath ] && ! echo $PATH | grep -q ${toolpath} ; then
        export PATH=${PATH}:${toolpath}
    fi
done
