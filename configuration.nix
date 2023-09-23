{ config, ... }:

{
  imports = [
    # Auto-generated configuration by NixOS
    ./hardware-configuration.nix
    # Custom configuration
    ./.nix
    ./bootloader
    ./hardware # Enable various hardware capabilities
    ./hardware/intel.nix
    ./hardware/network.nix
    ./hardware/virtualisation.nix
    ./system
    ./system/applications
    ./system/users
  ];

  config.system.stateVersion = config.system.state-version;
}
