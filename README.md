# Dotfiles

This is my personal dotfiles repository. It contains configuration files for:

- bash
- git
- hammerspoon
- micromamba
- starship
- to be continued...

It's based on homebrew for macOS and linuxbrew for Linux. It uses ansible for the installation.

## Installation

To install the dotfiles, run the following command:

```bash
git clone https://github.com/mi-skam/dotfiles
cd dotfiles
ansible-galaxy install -r requirements.yml
ansible-playbook -K --inventory playbook/inventory --limit localhost playbook/main.yml
```
