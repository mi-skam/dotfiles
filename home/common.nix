{ config, pkgs, ... }:

with pkgs;
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  fonts.fontconfig.enable = true; 

  home.file = {
    ".npmrc".text = ''
      prefix=$HOME/.npm-global
    '';
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs = {
    autojump.enable = true;
    bash = {
      enable = true;
      initExtra = ''
        . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        . $HOME/.nix-profile/etc/bash_completion.d/git-prompt.sh

        eval "$(${direnv}/bin/direnv hook bash)"


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

        export PATH=$HOME/.npm-global/bin:$PATH
      '';
      shellAliases = {
        hm = "home-manager";
      };
    };
    bat.enable = true;
    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };
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
        pull = {
          rebase = "true";
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
      forwardAgent = true;
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
    
    htop lazygit gitAndTools.gh neofetch zip unzip

    curl jq pypi2nix nixfmt shellcheck dos2unix imagemagick

    borgbackup

    ranger youtube-dl

    fira-code

    nodejs-12_x racket

    xdg_utils firefox
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.username = "$USER";
  home.homeDirectory = builtins.toPath (builtins.getEnv "HOME");

  home.stateVersion = "20.09";
}
