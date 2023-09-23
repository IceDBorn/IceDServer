{ config, pkgs, lib, ... }:

lib.mkIf config.system.user.main.enable {
  home-manager.users.${config.system.user.main.username} = {
    programs = {
      git = {
        enable = true;
        # Git config
        userName = "${config.system.user.main.git.username}";
        userEmail = "${config.system.user.main.git.email}";
      };

      zsh = {
        enable = true;

        # Install powerlevel10k
        plugins = with pkgs; [
          {
            name = "powerlevel10k";
            src = zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = zsh-nix-shell;
          }
        ];
      };
    };

    home.file = {
      # Add zsh theme to zsh directory
      ".config/zsh/zsh-theme.zsh" = {
        source = ../configs/zsh-theme.zsh;
        recursive = true;
      };

      # Add zsh theme to zsh directory
      ".config/zsh/scripts/post-install.sh" = {
        source = ../../scripts/post-install.sh;
      };

      # Add btop config
      ".config/btop/btop.conf" = {
        source = ../configs/btop.conf;
        recursive = true;
      };

      # Add nvchad
      ".config/nvim" = {
        source = "${(pkgs.callPackage ../self-built/nvchad.nix { })}";
        recursive = true;
      };

      ".config/nvim/lua/custom" = {
        source = ../configs/nvchad;
        recursive = true;
        force = true;
      };

      # Add tmux
      ".config/tmux/tmux.conf" = {
        source = ../configs/tmux.conf;
        recursive = true;
      };

      ".config/tmux/tpm" = {
        source = "${(pkgs.callPackage ../self-built/tpm.nix { })}";
        recursive = true;
      };

      ".bashrc" = {
        text = "";
        recursive = true;
      }; # Avoid file not found errors for bash
    };
  };
}
