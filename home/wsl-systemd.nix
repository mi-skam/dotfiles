{ config, pkgs, ... }:
{
  imports = [ 
    ./wsl.nix
    ./services/lorri.nix
  ];

}
