{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  fonts.fontconfig.enable = true; 


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs = {
    bash = {
      enable = true;
      enableAutojump = true;
      initExtra = ''
        . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        . $HOME/.nix-profile/etc/bash_completion.d/git-prompt.sh

        BLACK="\[\033[0;30m\]"
        BLUE="\[\033[0;34m\]"
        GREEN="\[\033[0;32m\]"
        CYAN="\[\033[0;36m\]"
        RED="\[\033[0;31m\]"
        PURPLE="\[\033[0;35m\]"
        BROWN="\[\033[0;33m\]"
        YELLOW="\[\033[1;33m\]"
        WHITE="\[\033[1;37m\]"
        NO_COLOUR="\[\033[0m\]"

        export GIT_PS1_SHOWDIRTYSTATE=1

        PS1="\u $BLUE\w$NO_COLOUR$GREEN\$(__git_ps1)$NO_COLOUR $RED❯$YELLOW❯$PURPLE❯$NO_COLOUR \$ "
      '';
      shellAliases = {
        hm = "home-manager";
      };
    };
    bat.enable = true;
    emacs = {
      enable = true;
      # package = pkgs.emacsGit;
    };
    git = { 
      enable = true;
      userName = "mi-skam";
      userEmail = "maksim.codes@mailbox.org";
      lfs.enable = true;
      extraConfig = {
        core = {
          git.pull = "true";
        };
      };
    };
    neovim = {
      enable = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
      extraConfig = ''
        set number
      '';
    };
    ssh = {
      enable = true;
      matchBlocks = {
        "web1.my" = {
          hostname = "web1.miskam.xyz";
          user = "admin";
        };
        "web2.my" = {
          hostname = "web2.miskam.xyz";
          user = "plumps";
          port = 22022;
        };
      };
    };
  };

  home.packages = with pkgs; [
    cacert fd ripgrep tldr 
    
    htop lazygit neofetch

    curl jq pypi2nix shellcheck

    fira-code

    nodejs-12_x
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "plumps";
  home.homeDirectory = "/home/plumps";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  services.lorri.enable = true;
}
