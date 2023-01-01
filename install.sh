#!/bin/bash
# downloads config repo and runs setup script

wget -q https://github.com/kyle-pike/config/archive/refs/tags/v1.0.tar.gz
tar -xzf v1.0.tar.gz; rm v1.0.tar.gz

mv config-1.0 config
chmod 700 config/*.sh*
sudo config/debian-setup.sh