# Setup.sh is part of FedoraSetup repository that contains files
# for automated post-install configuration of Fedora GNU/Linux
# Copyright (C) 2025 Denis Denisov (@DennimiCode)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#!/bin/bash

# Exit from script if ran as root
if [[ $USER == "root" ]]; then
  echo ERROR: "Do not run this script as root user!"
  exit 1
fi

# Remove unused apps & clean all dnf cache
sudo dnf remove -y kwrite neochat skanpage tuned-ppd kmail kontact kaddressbook krfb krdc akregator korganizer \
  '*games*' '*firefox*'
sudo dnf clean all

# Add addition software repositories
# LibreWolf
curl -fsSL https://repo.librewolf.net/librewolf.repo | sudo tee /etc/yum.repos.d/librewolf.repo

# Docker
curl -fsSL https://download.docker.com/linux/fedora/docker-ce.repo | sudo tee /etc/yum.repos.d/docker-ce.repo

# Teams for Linux
wget -q https://repo.teamsforlinux.de/teams-for-linux.asc -O- | rpm --import -
curl -1sLf https://repo.teamsforlinux.de/rpm/teams-for-linux.repo | sudo tee /etc/yum.repos.d/teams-for-linux.repo

# VirtualBox
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | rpm --import -
curl -fsSl https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo | \
sudo tee /etc/yum.repos.d/virtualbox.repo

# VSCodium
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
echo \
'[gitlab.com_paulcarroty_vscodium_repo]
name=VSCodium Repository
baseurl=https://download.vscodium.com/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
metadata_expire=1h' | sudo tee /etc/yum.repos.d/vscodium.repo

# MongoDB
echo \
'[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc' | sudo tee /etc/yum.repos.d/mongodb-org-8.0.repo

# Add Flatpak repositories
flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Updating repositories
sudo dnf update --refresh

# Install software
sudo dnf install -y fish librewolf teams-for-linux chromium codium sqlitebrowser obs-studio gimp inkscape qemu piper \
  qbittorrent remmina tmux alacritty evolution-ews evolution fastfetch filezilla tlp flatpak plasma-discover-flatpak \
  krita simple-scan VirtualBox-7.1 virt-manager lsd

# Install development software
sudo dnf install -y git nodejs javac go dotnet-sdk-9.0 dotnet-sdk-8.0 dotnet-runtime-8.0 dotnet-runtime-9.0 \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin python3-virtualenv \
  postgresql-server postgresql-libs postgresql-contrib postgresql-devel cmake gcc-c++ extra-cmake-modules kwin-devel \
  kf6-kconfigwidgets-devel libepoxy-devel kf6-kcmutils-devel kf6-ki18n-devel qt6-qtbase-private-devel wayland-devel \
  libdrm-devel mongodb-org mongodb-mongosh langpacks-ru

# Install bun
curl -fsSL https://bun.sh/install | bash

# Install ZED text editor
curl -f https://zed.dev/install.sh | sh

# Install Flatpak apps
flatpak install -y flathub com.rtosta.zapzap com.github.tchx84.Flatseal com.usebottles.bottles com.discordapp.Discord \
  com.github.d4nj1.tlpui me.timschneeberger.GalaxyBudsClient org.localsend.localsend_app

# Creating local temp directory
mkdir -p ./tmp/

# Create Applications directory for AppImage apps
mkdir -p $HOME/Applications

# Create directory for AppImage apps, which does not have icons in papirus-icon-theme & copy all icons to it
mkdir -p $HOME/Applications/icons
cp -r ./AppIcons/* $HOME/Applications/icons

# Download AppImage apps
wget 'https://vault.bitwarden.com/download/?app=desktop&platform=linux' -O ./Bitwarden.AppImage
wget 'https://apps.webinar.ru/desktop/latest/mts-link-desktop.AppImage' -O ./MTSLink.AppImage

# 'Install' AppImage apps
chmod +x ./*.AppImage
mv ./*.AppImage $HOME/Applications/

# Download tar.gz apps
wget 'https://dl.pstmn.io/download/latest/linux_64' -O ./tmp/postman.tar.gz
wget 'https://telegram.org/dl/desktop/linux' -O ./tmp/telegram-desktop.tar.xz
wget 'https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz' -O ./tmp/nvim.tar.gz

# Extract tar & tar.gz apps
sudo tar -xvf ./tmp/telegram-desktop.tar.xz -C /opt/
sudo tar -xvzf ./tmp/postman.tar.gz -C /opt/
sudo rm -rf /opt/nvim; sudo mkdir -p /opt/nvim; sudo tar -C /opt/nvim/ --strip-components=1 -xvzf ./tmp/nvim.tar.gz \
nvim-linux-x86_64

# Download & install rpm apps
sudo dnf install -y 'https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm' \
  'https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm' \
  'https://anytype-release.fra1.cdn.digitaloceanspaces.com/anytype-0.47.5.x86_64.rpm' \
  'https://cdn.zoom.us/prod/6.5.3.2773/zoom_x86_64.rpm' \
  'https://downloads.mongodb.com/compass/mongodb-compass-1.46.5.x86_64.rpm' \
  'https://download2.gluonhq.com/scenebuilder/23.0.1/install/linux/SceneBuilder-23.0.1.rpm' \
  'https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors.x86_64.rpm'

# Install cursor theme
wget 'https://github.com/ful1e5/apple_cursor/releases/download/v2.0.1/macOS.tar.xz' -O ./tmp/macOS.tar.xz
sudo tar -xvf ./tmp/macOS.tar.xz -C /usr/share/icons/

# Pass directories to Flatpak to allow Flatpak apps use system theme
sudo flatpak override --filesystem=xdg-config/gtk-3.0
sudo flatpak override --filesystem=xdg-config/gtk-4.0

# Make fish as default shell
chsh -s $(which fish)
sudo chsh -s $(which fish)

# Download & install fonts
wget 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip' \
-O ./tmp/JetBrainsMonoNerdFonts.zip
wget 'https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip' -O ./tmp/JetBrainsMono.zip

sudo unzip -j ./tmp/JetBrainsMono.zip *.ttf -d /usr/local/share/fonts/
sudo unzip -j ./tmp/JetBrainsMonoNerdFonts.zip *.ttf -d /usr/local/share/fonts/

# Install config files
# Clone repository with config files
git clone https://github.com/DennimiCode/dotfiles.git ./tmp/dotfiles/

# Clone NdVim repository & 'install' it
mkdir -p $HOME/.config/nvim
git clone git@github.com:DennimiCode/NdVim.git $HOME/.config/nvim

# Install Alacritty terminal config
mkdir -p $HOME/.config/alacritty
cp ./tmp/dotfiles/alacritty/alacritty.toml $HOME/.config/alacritty/

# Install fish config
mkdir -p $HOME/.config/fish
cp -f ./tmp/dotfiles/fish/* $HOME/.config/fish

# Install Tmux config
cp -f ./tmp/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf

# Install ideavim config (VIM mode plugin for JetBrains IDEs)
cp -f ./tmp/dotfiles/jetbrains/.ideavimrc $HOME/.ideavimrc

# Install DNF config
sudo cp -f ./tmp/dotfiles/dnf/dnf.conf /etc/dnf/dnf.conf

# Make symlink to NeoVim
sudo ln -s /opt/nvim/bin/nvim /usr/bin/nvim

# Enable TLP
sudo tlp start

# Add current user to KVM & VirtualBox groups
sudo gpasswd -a $USER libvirt
sudo usermod -aG vboxusers $USER
sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG libvirt-dnsmasq $USER

# Enable service for waking up from suspend
echo \
"[Unit]
Description=Enable USB Wakeup
After=multi-user.target

[Service]
Tyhpe=oneshot
ExecStart=/bin/bash -c 'for f in /sys/bus/usb/devices/*/power/wakeup; do echo enabled > '\$f'; done'

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/enable-usb-wakeup.service

sudo systemctl daemon-reexec

# Start installed services
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl start tlp
sudo systemctl enable tlp
sudo systemctl start enable-usb-wakeup.service
sudo systemctl enable enable-usb-wakeup.service

# Create desktop files
./tools/create_desktop_files.sh

# Install corp software
./tools/install_corp_software.sh

# Switch VSCodium open-vsx extensions repository to vscode (proprietary) repository
./tools/enable-vscode-marketplace-vscodium.sh

# Add MIME handler for MTS Link (fix for SSO authorization in MTS Link AppImage)
sudo xdg-mime default MTSLink.desktop x-scheme-handler/wbnr

# Remove downloaded packages, archives & directories
read -p "Do you want to keep temp files from ./tmp directory?(y/N): " TMP_DELETE_CONFIRM
if [[ $TMP_DELETE_CONFIRM != [yY] || $TMP_DELETE_CONFIRM != [yY][eE][sS] ]]; then
  sudo rm -rf ./tmp/
fi
