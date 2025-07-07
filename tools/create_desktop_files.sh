# create_desktop_files.sh is part of FedoraSetup repository that contains files
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

touch $HOME/.local/share/applications/Postman.desktop
touch $HOME/.local/share/applications/Bitwarden.desktop
touch $HOME/.local/share/applications/MTSLink.desktop

echo \
"[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Terminal=false
Name=Postman
Comment=Supercharge your API workflow
Icon=postman
Exec=/opt/Postman/Postman
Categories=Development;" > $HOME/.local/share/applications/Postman.desktop

echo \
"[Desktop Entry]
Type=Application
Name=Bitwarden
Icon=bitwarden
Comment=The password manager trusted by millions
Exec=/home/${USER}/Applications/Bitwarden.AppImage %u
Encoding=UTF-8
Terminal=false
Categories=Utility;" > $HOME/.local/share/applications/Bitwarden.desktop

echo \
"[Desktop Entry]
Type=Application
Name=MTS Link
Icon=/home/${USER}/Applications/icons/mts-link-icon.png
Comment=Экосистема сервисов для бизнес‑коммуникаций и совместной работы
Exec=/home/${USER}/Applications/MTSLink.AppImage %u
Encoding=UTF-8
Terminal=false
Categories=Network;" > $HOME/.local/share/applications/MTSLink.desktop

# Also create desktop files for games
if [[ $1 != "" && $1 == "with-gaming" ]]; then
  touch $HOME/.local/share/applications/Goverlay.desktop
  touch $HOME/.local/share/applications/BadlionClient.desktop
  touch $HOME/.local/share/applications/LunarClient.desktop

  echo \
  "[Desktop Entry]
  Type=Application
  Name=Goverlay
  Icon=goverlay
  Comment=GOverlay is an open source project aimed to create a Graphical UI to manage Vulkan/OpenGL overlays.
  Exec=/opt/goverlay
  Encoding=UTF-8
  Terminal=false
  Categories=Game;" > $HOME/.local/share/applications/Goverlay.desktop

  echo \
  "[Desktop Entry]
  Type=Application
  Name=Badlion Client
  Icon=BadlionClient
  Comment=The Best All-in-One Minecraft Mod Library.
  Exec=/home/${USER}/Applications/BadlionClient.AppImage
  Encoding=UTF-8
  Terminal=false
  Categories=Game;" > $HOME/.local/share/applications/BadlionClient.desktop

  echo \
  "[Desktop Entry]
  Type=Application
  Name=Lunar Client
  Icon=lunarclient
  Comment=The #1 Free Minecraft Client.
  Exec=/home/${USER}/Applications/LunarClient.AppImage
  Encoding=UTF-8
  Terminal=false
  Categories=Game;" > $HOME/.local/share/applications/LunarClient.desktop
fi
