#!/usr/bin/env bash

# nix installieren (nicht auf NIXOS)
if [ ! -f /etc/NIXOS ]; then
        user_id=$(id -u)
        group=$(id -g)
	install -d -m -o $user_id -g $group /nix
        source <(curl -s -N -L https://nixos.org/nix/install)
	source /home/$USER/.nix-profile/etc/profile.d/nix.sh
	echo "READY: Nix is now in your path"
fi
# home-manager installieren
 nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
 nix-channel --update
 export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
 nix-shell '<home-manager>' -A install
