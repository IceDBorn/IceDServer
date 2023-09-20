{ ... }:

{
  networking.interfaces = { };
  networking.networkmanager.enable = false;
  systemd.network.enable = false;
}
