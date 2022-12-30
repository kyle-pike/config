#!/bin/bash
# one liner to install everything 


wget https://github.com/kyle-pike/config/releases/download/v1.0/config.tar.gz
tar -xzvf config.tar.gz; rm config.tar.gz
sudo debian-setup.sh