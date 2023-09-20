{ config, lib, ... }:

{
  # Set memory limits
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = "2147483648";
    }

    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "2147483648";
    }
  ];

  services.fstrim.enable = true; # Enable SSD TRIM

  fileSystems = lib.mkIf (config.hardware.btrfs-compression.enable
    && config.hardware.btrfs-compression.root.enable) {
      "/".options = [ "compress=zstd" ];
    };

}
