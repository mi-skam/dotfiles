{ config, pkgs, ... }:
let
  gitCredentialManager = pkgs.writeScriptBin "git-credential-manager" ''
    #!${pkgs.stdenv.shell}
    exec /windows/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe $@
  '';

in
{
    imports = [ ./common.nix ];

    programs.bash = {
      shellAliases = {
        nmap = "'/windows/c/Program Files (x86)/Nmap/nmap.exe'";
      };
    };
    programs.git = { 
      extraConfig = {
        credential = { helper = "${gitCredentialManager}/bin/git-credential-manager"; };
      };
    };

    home.sessionVariables = {
      DISPLAY = "172.24.224.1:0";
      PULSE_SERVER = "tcp:ohmy";
    };


}
