#!/usr/bin/env bash

set -euo pipefail

### GLOBALS

INSTALL_PATH=$HOME/.dotfiles

### HELPER

function ready() {
	message=$1
	green='\033[0;32m'
	yellow='\033[1;33m'
	no_color='\033[0m'
	echo -e "${green}READY:${yellow} $message${no_color}"
}

function on_wsl() {
	uname -a | grep -q microsoft
}

function get_release() {
	read -r -p "Nix, Home-Manager release? (master, release-20.03,...) " answer

	while true; do
		case $answer in
		master*)
			release=master
			break
			;;
		release-*)
			release=$answer
			break
			;;

		*) exit ;;
		esac
	done
}

function install_nix() {
	# Nix installieren (nicht auf NIXOS)
	if [ ! -f /etc/NIXOS ]; then
		source <(curl -s -N -L https://nixos.org/nix/install)
		source "/home/$USER/.nix-profile/etc/profile.d/nix.sh"
		ready "Nix is now in your path"
	fi

}

function install_hm() {
	# Home-Manager installieren
	nix-channel --add "https://github.com/rycee/home-manager/archive/$release.tar.gz" home-manager
	nix-channel --update
	export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
	nix-shell '<home-manager>' -A install
	ready "Home-Manager is now in your path"
}

### START

# if there is more than one argument then access $1, otherwise ask the user
[ "$#" -ge 1 ] && release=$1
shift || get_release

# checkout dotfiles repo
[ ! -d "$INSTALL_PATH" ] && git clone https://github.com/mi-skam/dotfiles "$INSTALL_PATH"
pushd "$INSTALL_PATH"

# nix und hm installieren
install_nix
install_hm

# nix und home-manager konfigurationen verlinken
rm -rf ~/.config/nixpkgs/*
ln -snf "$(pwd)/config.nix" ~/.config/nixpkgs/config.nix
ln -snf "$(pwd)/home/common.nix" ~/.config/nixpkgs/common.nix

if on_wsl; then
	ln -snf "$(pwd)/home/wsl.nix" ~/.config/nixpkgs/home.nix
else
	ln -snf "$(pwd)/home/linux.nix" ~/.config/nixpkgs/home.nix
fi
ready "Configurations are now linked to ~/.config/nixpkgs"
home-manager -b bak switch

### END
popd
