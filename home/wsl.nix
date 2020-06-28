{ config, pkgs, ... }:
let
  gitCredentialManager = pkgs.writeScriptBin "git-credential-manager" ''
    #!${pkgs.stdenv.shell}
    exec /windows/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe $@
  '';

in
{
    imports = [ ./common.nix ];

    programs.git = { 
      extraConfig = {
        credential = { helper = "${gitCredentialManager}/bin/git-credential-manager"; };
      };
    };
}
