{ ... }:

{
  imports = [
    ./global.nix # Packages installed globally
    # Home manager specific stuff
    ./home/main.nix
  ];

  nix = {
    settings = {
      # Use hard links to save space (slows down package manager)
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ]; # Enable flakes
    };

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary packages
    permittedInsecurePackages = [ "openssl-1.1.1v" ];
  };
}
