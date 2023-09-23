#!/usr/bin/env bash

# Set mullvad config options
mullvad auto-connect set on
mullvad lan set allow
mullvad relay set tunnel-protocol wireguard
mullvad relay set location bg sof

# Install portainer for docker
docker run -d -pp 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
