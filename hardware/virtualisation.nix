{ pkgs, config, lib, ... }:

{
  virtualisation = {
    docker.enable = config.hardware.virtualisation.docker.enable;
    libvirtd.enable = config.hardware.virtualisation.libvirtd.enable;
    lxd.enable = config.hardware.virtualisation.lxd.enable;
    spiceUSBRedirection.enable =
      config.hardware.virtualisation.spiceUSBRedirection.enable;

    oci-containers = {
      backend = "docker";

      containers = {
        portainer =
          lib.mkIf config.hardware.virtualisation.containers.portainer.enable {
            image = "portainer/portainer-ce:latest";
            ports = [ "9443:9443" ];
            volumes = [
              "/var/run/docker.sock:/var/run/docker.sock"
              "portainer_data:/data"
            ];
          };

        stremio =
          lib.mkIf config.hardware.virtualisation.containers.stremio.enable {
            image = "stremio/server:latest";
            ports = [ "11470:11470" ];
          };

        tailscale =
          lib.mkIf config.hardware.virtualisation.containers.tailscale.enable {
            image = "tailscale/tailscale:latest";
            volumes = [ "tailscale:/var/lib" "/dev/net/tun:/dev/net/tun" ];
            extraOptions = [ "--cap-add=NET_ADMIN" "--cap-add=NET_RAW" ];

            environment = {
              TS_ACCEPT_DNS = "true";
              TS_AUTH_ONCE = "true";
              TS_USERSPACE = "false";
              TS_STATE_DIR = "/var/lib/tailscale";
              TS_EXTRA_ARGS = "--accept-routes=true --advertise-exit-node";
              TS_AUTHKEY =
                config.hardware.virtualisation.containers.tailscale.authkey;
            };
          };
      };
    };
  };

  environment.systemPackages = with pkgs;
    lib.mkIf config.hardware.virtualisation.docker.enable [
      # Containers
      docker
      docker-compose
    ];
}
