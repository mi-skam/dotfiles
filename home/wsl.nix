{ config, pkgs, ... }:
let
  gitCredentialManager = pkgs.writeScriptBin "git-credential-manager" ''
    #!${pkgs.stdenv.shell}
    exec /mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe $@
  '';

  getDisplay = pkgs.writeScriptBin "gd" ''
    #!${pkgs.stdenv.shell}
    awk '/nameserver/ { print $2 }' < /etc/resolv.conf
  '';

  sshRelay = pkgs.writeScriptBin "ssh-relay" ''
    #!${pkgs.stdenv.shell}
    setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Users/plumps/bin/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &  >/dev/null 2>&1
  '';
in
{
    imports = [ ./common.nix ];

    programs.bash = {
      initExtra = ''
        if [ -f  $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
          . $HOME/.nix-profile/etc/profile.d/nix.sh
        fi
        export DISPLAY=$(${getDisplay}/bin/gd):0.0

        export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
        ss -a | grep -q $SSH_AUTH_SOCK
        if [ $? -ne 0   ]; then
          rm -f $SSH_AUTH_SOCK
          ${sshRelay}/bin/ssh-relay
        fi


      '';

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
      PULSE_SERVER = "tcp:ohmy";
    };


}
