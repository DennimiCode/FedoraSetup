# install_corp_software.sh is part of FedoraSetup repository that contains files
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

wget -qO- "https://mirror.mts.ru/byod/linux/scripts/certs.sh" | sudo bash
wget -qO- "https://mirror.mts.ru/byod/linux/scripts/vpn.sh" | sudo bash
sudo dnf install -y "https://mirror.mts.ru/byod/linux/vdi/ICAClient-rhel-25.05.0.44-0.x86_64.rpm"

# Hiding citrixlog user
echo \
"[User]
SystemAccount=true" | sudo tee /var/lib/AccountsService/users/citrixlog

sudo systemctl restart accounts-daemon.service
