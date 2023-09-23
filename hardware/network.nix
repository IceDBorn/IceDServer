{ config, pkgs, ... }:

{
  networking = {
    firewall.enable = false;

    # Static IP
    interfaces = {
      ${config.hardware.networking.interface} = {
        ipv4 = {
          addresses = [{
            address = config.hardware.networking.ip;
            prefixLength = 24;
          }];
        };
      };
    };

    defaultGateway = {
      address = config.hardware.networking.gateway;
      interface = config.hardware.networking.interface;
    };

    nameservers = [ config.hardware.networking.dns ];

    # Enable vpn sharing
    nat = {
      enable = true;
      internalInterfaces = [ config.hardware.networking.interface ];
    };

    networkmanager.enable = false;
  };
  systemd.network.enable = false;

  # Enable dnsmaq for DNS proxying
  environment.systemPackages = [ pkgs.dnsmasq ];
  services.dnsmasq = {
    enable = true;
    settings = {
      resolv-file = "/etc/resolv.conf";
      listen-address = config.hardware.networking.ip;
    };
  };
}
