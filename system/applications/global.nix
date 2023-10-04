# PACKAGES INSTALLED ON ALL USERS
{ pkgs, config, ... }:

let
  # Logout from any shell
  lout = pkgs.writeShellScriptBin "lout" ''
    pkill -KILL -u $USER
  '';

  # Garbage collect the nix store
  nix-gc = pkgs.writeShellScriptBin "nix-gc" ''
    gens=${config.system.gc.generations} ;
    days=${config.system.gc.days} ;
    trim-generations ''${1:-$gens} ''${2:-$days} user ;
    trim-generations ''${1:-$gens} ''${2:-$days} home-manager ;
    sudo trim-generations ''${1:-$gens} ''${2:-$days} system ;
    nix-store --gc
  '';

  post-login = pkgs.writeShellScriptBin "post-install" ''
    mullvad auto-connect set on
    mullvad lan set allow
    mullvad relay set tunnel-protocol wireguard
    mullvad relay set location bg sof
    mullvad connect
    tailscale up
  '';

  # Rebuild the system configuration
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    # Arguments for update and main user specific commands
    ARG1=''${1:-0}

    # Stash flake.lock
    function stashLock() {
      git stash store $(git stash create) -m "flake.lock@$(date +%A-%d-%B-%T)"
    }

    # Navigate to configuration directory
    cd ${config.system.configuration-location} 2> /dev/null ||
    (echo 'Configuration path is invalid. Run build.sh manually to update the path!' && false) &&

    # Update specific commands
    if [ $ARG1 -eq 1 ]; then
      # Stash the flake lock file
      if [ $(git stash list | wc -l) -eq 0 ]; then
        stashLock
      else
        [ -n "$(git diff stash flake.lock)" ] && stashLock
      fi

      nix flake update && bash build.sh
    else
      bash build.sh
    fi
  '';

  # Trim NixOS generations
  trim-generations = pkgs.writeShellScriptBin "trim-generations"
    (builtins.readFile ../scripts/trim-generations.sh);

  update = pkgs.writeShellScriptBin "update" "rebuild 1";

  codingDeps = with pkgs; [
    cargo # Rust package manager
    dotnet-sdk_7 # SDK for .net
    gcc # C++ compiler
    gdtoolkit # Tools for gdscript
    nixfmt # A nix formatter
    nodejs # Node package manager
    python3 # Python
    vscodium # All purpose IDE
  ];

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  nvchadDeps = with pkgs; [
    beautysh # Bash formatter
    black # Python formatter
    lazygit # Git CLI UI
    libclang # C language server and formatter
    lua-language-server # Lua language server
    marksman # Markdown language server
    neovim # Terminal text editor
    nil # Nix language server
    nodePackages.bash-language-server # Bash Language server
    nodePackages.dockerfile-language-server-nodejs # Dockerfiles language server
    nodePackages.prettier # Javascript/Typescript formatter
    nodePackages.typescript-language-server # Typescript language server
    nodePackages.vscode-langservers-extracted # HTML, CSS, Eslint, Json language servers
    python3Packages.jedi-language-server # Python language server
    ripgrep # Silver searcher grep
    rust-analyzer # Rust language server
    rustfmt # Rust formatter
    stylua # Lua formatter
  ];

  shellScripts = [ lout nix-gc post-login rebuild trim-generations update ];
in {
  boot.kernelPackages = pkgs.linuxPackages_zen; # Use ZEN linux kernel

  environment.systemPackages = with pkgs;
    [
      aria # Terminal downloader with multiple connections support
      bat # Better cat command
      btop # System monitor
      clamav # Antivirus
      fd # Find alternative
      git # Distributed version control system
      gping # ping with a graph
      jc # JSON parser
      jq # JSON parser
      killall # Tool to kill all programs matching process name
      lout # Logout from any shell
      lsd # Better ls command
      mullvad # VPN
      ncdu # Terminal disk analyzer
      nix-gc # Garbage collect old nix generations
      ntfs3g # Support NTFS drives
      p7zip # 7zip
      post-login # Script to run after logging in to vpn services
      ranger # Terminal file manager
      rebuild # Rebuild the system configuration
      tailscale # VPN with P2P support
      tmux # Terminal multiplexer
      tree # Display folder content at a tree format
      trim-generations # Smarter old nix generations cleaner
      unrar # Support opening rar files
      unzip # An extraction utility
      update # Update the system configuration
      wget # Terminal downloader
    ] ++ codingDeps ++ nvchadDeps ++ myPackages ++ shellScripts;

  users.defaultUserShell = pkgs.zsh; # Use ZSH shell for all users

  programs = {
    zsh = {
      enable = true;
      # Enable oh my zsh and it's plugins
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "npm" "sudo" "systemd" ];
      };
      autosuggestions.enable = true;

      syntaxHighlighting.enable = true;

      # Aliases
      shellAliases = {
        aria2c = "aria2c -j 16 -s 16"; # Download with aria using best settings
        btrfs-compress =
          "sudo btrfs filesystem defrag -czstd -r -v"; # Compress given path with zstd
        cat = "bat"; # Better cat command
        chmod = "sudo chmod"; # It's a command that I always execute with sudo
        cp = "rsync -rP"; # Copy command with details
        list-packages =
          "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq"; # List installed nix packages
        ls = "lsd"; # Better ls command
        mva = "rsync -rP --remove-source-files"; # Move command with details
        n = "tmux a -t nvchad || tmux new -s nvchad nvim"; # Nvchad
        ping = "gping"; # ping with a graph
        ssh = "TERM=xterm-256color ssh"; # SSH with colors
        v = "nvim"; # Neovim
      };

      interactiveShellInit = ''
        source ~/.config/zsh/zsh-theme.zsh
        unsetopt PROMPT_SP''; # Commands to run on zsh shell initialization
    };
  };

  services = {
    clamav.updater.enable = true;
    mullvad-vpn.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
  };
}
