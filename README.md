# Dotfiles

This is my personal dotfiles repository. It contains configuration files for:

- bash
- git
- hammerspoon
- micromamba
- starship
- to be continued...

It's based on homebrew for macOS and linuxbrew for Linux. It uses ansible for the installation.

### TODO

- [ ] Add more configuration files
- [ ] Update the linuxbrew installation (especially the packages)

Credits go to

- [webpro](https://github.com/webpro/dotfiles/)
- [geerlingguy](https://github.com/geerlingguy/mac-dev-playbook)

## Installation

To install the dotfiles, run the following command:

```bash
git clone https://github.com/mi-skam/dotfiles
cd dotfiles
ansible-galaxy install -r requirements.yml
ansible-playbook -K --inventory playbook/inventory --limit localhost playbook/main.yml
```
