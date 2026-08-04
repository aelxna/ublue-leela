#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Enable Terra
echo "Setting up Terra repository..."
if ! dnf5 repolist --all | grep -q '^terra '; then
  echo "Installing Terra repository..."
  curl -fsSL https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo -o /etc/yum.repos.d/terra.repo
  dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release || true
fi

echo "Enabling Terra repository..."
dnf5 config-manager setopt terra.enabled=1

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y --skip-unavailable --skip-broken \
  kde-connect \
  ghostty \
  starship \
  zoxide \
  eza \
  fzf \
  ripgrep \
  direnv \
  neovim \
  fd-find \
  mpv \
  tailscale \

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
