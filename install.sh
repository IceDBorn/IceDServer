#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
pwd > .configuration-location

RED='\033[0;31m'
NC='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

username=$(whoami)
export username

echo "Hello $username!"

read -r -p "Have you customized the setup to your needs? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # Add configuration files to the appropriate path
    sudo cp -r `ls -A | grep -v ".git"` /etc/nixos

    # Build the configuration
    sudo nixos-rebuild switch
else
    printf "You really should:
    - Edit .nix, configuration.nix and comment out anything you do not want to setup."
fi
