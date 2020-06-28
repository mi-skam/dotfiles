#!/usr/bin/env bash

# setup

read -p "Nix, Home-Manager release? (master, release-20.03,...) " release

while true
do
  case $release in
    master* ) nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
	      break;;
    release-* ) nix-channel --add https://github.com/rycee/home-manager/archive/$answer.tar.gz home-manager
	      break;;

	* ) exit;;
  esac
done


# nix installieren (nicht auf NIXOS)
if [ ! -f /etc/NIXOS ]; then
        source <(curl -s -N -L https://nixos.org/nix/install)
	source /home/$USER/.nix-profile/etc/profile.d/nix.sh
	echo "READY: Nix is now in your path"
fi
# home-manager installieren
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
echo "READY: Home-Manager is now in your path"
