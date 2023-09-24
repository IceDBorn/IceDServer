{ lib, ... }:

{
  options = with lib; {
    boot = {
      efi-mount-path = mkOption {
        type = types.str;
        default = "/boot";
      };
    };

    hardware = {
      btrfs-compression = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Use btrfs compression for root
        root.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };

      cpu = {
        intel.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };

      networking = {
        dns = mkOption {
          type = types.str;
          default = "9.9.9.9";
        };

        gateway = mkOption {
          type = types.str;
          default = "192.168.1.1";
        };

        interface = mkOption {
          type = types.str;
          default = "eno1";
        };

        ip = mkOption {
          type = types.str;
          default = "192.168.1.2";
        };
      };

      virtualisation = {
        # Containers to build with docker
        containers = {
          # Control panel for docker
          portainer.enable = mkOption {
            type = types.bool;
            default = true;
          };

          # Stremio caching server
          stremio.enable = mkOption {
            type = types.bool;
            default = true;
          };

          # VPN server
          tailscale = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };

            # This key is only needed to login on the first run
            authkey = mkOption {
              type = types.str;
              default = "TAILSCALE_AUTHENTICATION_KEY";
            };
          };

        };

        # Container manager
        docker.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # A daemon that manages virtual machines
        libvirtd.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Container daemon
        lxd.enable = mkOption {
          type = types.bool;
          default = true;
        };

        # Passthrough USB devices to vms
        spiceUSBRedirection.enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };

    system = {
      gc = {
        # Number of days before a generation can be deleted
        days = mkOption {
          type = types.str;
          default = "0";
        };

        # Number of generations that will always be kept
        generations = mkOption {
          type = types.str;
          default = "10";
        };
      };

      user = {
        main = {
          enable = mkOption {
            type = types.bool;
            default = true;
          };

          username = mkOption {
            type = types.str;
            default = "server";
          };

          description = mkOption {
            type = types.str;
            default = "Server";
          };

          git = {
            username = mkOption {
              type = types.str;
              default = "IceDBorn";
            };

            email = mkOption {
              type = types.str;
              default = "github.envenomed@dralias.com";
            };
          };
        };
      };

      # Do not change without checking the docs (config.system.stateVersion)
      state-version = mkOption {
        type = types.str;
        default = "23.05";
      };
    };
  };
}
