#!/usr/bin/env bash

# setup

function on_wsl {
	uname -a | grep -q microsoft 
}

read -p "Nix, Home-Manager release? (master, release-20.03,...) " answer

while true
do
  case $answer in
    master* ) release=master.tar.gz
	      break;;
    release-* ) release=$answer.tar.gz
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
nix-channel --add https://github.com/rycee/home-manager/archive/$release home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
echo "READY: Home-Manager is now in your path"

# nix und home-manager konfigurationen verlinken
ln -snf "$(pwd)/config.nix" ~/.config/nixpkgs/config.nix
ln -snf "$(pwd)/home/common.nix" ~/.config/nixpkgs/common.nix

if on_wsl; then
	ln -snf "$(pwd)/home/wsl.nix" ~/.config/nixpkgs/home.nix
else 
	ln -snf "$(pwd)/home/linux.nix" ~/.config/nixpkgs/home.nix
fi
echo "READY: Configurations are now linked to ~/.config/nixpkgs"
home-manager switch
