{ pkgs, config, lib, ... }:

{
  virtualisation = {
    docker.enable = config.hardware.virtualisation.docker.enable;
    libvirtd.enable = config.hardware.virtualisation.libvirtd.enable;
    lxd.enable = config.hardware.virtualisation.lxd.enable;
    spiceUSBRedirection.enable =
      config.hardware.virtualisation.spiceUSBRedirection.enable;
  };

  environment.systemPackages = with pkgs;
    lib.mkIf config.hardware.virtualisation.docker.enable [
      # Containers
      docker
      docker-compose
    ];
}
