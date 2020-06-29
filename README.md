# dotfiles

## Dependencies

- git

## Installation

1. As a oneliner
```bash
curl -fsSL https://raw.githubusercontent.com/mi-skam/dotfiles/master/install.sh | bash -s master # or...
curl -fsSL https://raw.githubusercontent.com/mi-skam/dotfiles/master/install.sh | bash -s release-20.03
```
2. Clone the repository.
```bash
git clone https://github.com/mi-skam/dotfiles
cd dotfiles
./install # or...
./install master # or ..
./install release-20.03
```

## Post-Install

On Non-Nixos systems running on WSL we need to create some entries in wsl.conf

1. Create the wsl.conf

```bash
(cat <<HERE
[automount]
root = "/windows"
HERE
    ) | sudo tee /etc/wsl.conf
```
2. Kill the wsl instance
```powershell
wsl -t <DistributionName>
```