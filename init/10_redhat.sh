# RHEL-only stuff. Abort if not Red Hat
[[ `platform_dist` == redhat ]] || return 1

# Install packages.
e_header "Installing YUM packages"
sudo yum install git tree htop screen
