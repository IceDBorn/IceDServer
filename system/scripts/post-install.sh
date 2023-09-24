#!/usr/bin/env bash

# Set mullvad config options
mullvad auto-connect set on
mullvad lan set allow
mullvad relay set tunnel-protocol wireguard
mullvad relay set location bg sof
tailscale up
