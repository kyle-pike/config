#!/bin/bash
# downloads config repo and runs setup script

#wget -q https://github.com/kyle-pike/config/archive/refs/tags/v1.1.tar.gz
#tar -xzf v1.1.tar.gz; rm v1.1.tar.gz

LATEST_VERSION=$(curl -s https://api.github.com/repos/kyle-pike/config/releases/latest | grep tag_name | cut -d '"' -f4)

curl --location https://api.github.com/repos/kyle-pike/config/tarball/"${LATEST_VERSION}" -o config.tar.gz
mkdir config-"${LATEST_VERSION}"
tar -xzf config.tar.gz -C config-"${LATEST_VERSION}" --strip-components=1
rm config.tar.gz
mv config* config
chmod 755 config/*.sh*
sudo config/debian-setup.sh
