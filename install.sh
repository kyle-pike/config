#!/bin/bash
# downloads config repo and runs setup script

wget -q https://github.com/kyle-pike/config/archive/refs/tags/v1.1.tar.gz
tar -xzf v1.1.tar.gz; rm v1.1.tar.gz

mv config* config
chmod 700 config/*.sh*
sudo config/debian-setup.sh