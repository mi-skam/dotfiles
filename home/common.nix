{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs = {
    bash = {
      enable = true;
      enableAutojump = true;
      initExtra = ''
	      . /home/plumps/.nix-profile/etc/profile.d/nix.sh
        . /home/plumps/.nix-profile/etc/profile.d/hm-session-vars.sh
      '';
    };
    bat.enable = true;
    emacs = {
      enable = true;
    };
    firefox = {
      enable = true;
    };
    git = { 
      enable = true;
      userName = "mi-skam";
      userEmail = "maksim.codes@mailbox.org";
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
  };

  home.packages = with pkgs; [
    cacert fd ripgrep tldr 
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
}
