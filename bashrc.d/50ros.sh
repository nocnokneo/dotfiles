if [ -f ${ROS_ROOT}/tools/rosbash/rosbash ]; then
    . ${ROS_ROOT}/tools/rosbash/rosbash
fi

# arg: new ROS workspace (e.g. ~/ros)
function rosswitch {
    stale_paths="$(readlink -f ${ROS_ROOT}/../eros/tools/eros_python_tools/scripts) ${ROS_ROOT}/bin"
    # Remove all stale paths in PATH (from previous ROS_ROOT)
    for p in ${stale_paths}; do
        PATH=$(echo ${PATH} | sed -r -e "s;(^|:)${p}(:|$);:;g" | sed -e 's;^:;;' | sed -e 's;:$;;' | sed -e 's;::;;')
    done
    export PATH
    unset ROS_ROOT ROS_PACKAGE_PATH ROS_MASTER_URI ROS_WORKSPACE

    # setup the new ROS_ROOT
    ros_workspace="$(readlink -f "${1}")" . ${HOME}/.profile.d/ros.sh
}
