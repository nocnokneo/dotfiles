# Ubuntu-only stuff. Abort if not Ubuntu.
if ! type apt &> /dev/null; then
    return
fi

# Update APT.
e_header "Updating APT cache"
sudo apt-get -qq update

# Install APT packages.
e_header "Installing APT packages"
sudo apt-get install git-core tree nmap htop screen undistract-me colordiff
