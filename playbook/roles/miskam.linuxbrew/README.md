# Ansible Role: Linuxbrew

(Fork of [geerlingguy
/
ansible-collection-mac
](https://github.com/geerlingguy/ansible-collection-mac/tree/master/roles/homebrew))

Installs [Homebrew][homebrew] on ~~MacOS~~ Linux, and configures packages, taps, and ~~cask apps~~ according to supplied variables.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see [`defaults/main.yml`](defaults/main.yml)):

    homebrew_repo: https://github.com/Homebrew/brew

The GitHub repository for Homebrew core.

    homebrew_prefix: "{{ (ansible_machine == 'arm64') | ternary('/opt/homebrew', '/usr/local') }}"
    homebrew_install_path: "{{ homebrew_prefix }}/Homebrew"

The path where Homebrew will be installed (`homebrew_prefix` is the parent directory). It is recommended you stick to the default, otherwise Homebrew might have some weird issues. If you change this variable, you should also manually create a symlink back to /usr/local so things work as Homebrew expects.

    homebrew_brew_bin_path: /usr/local/bin

The path where `brew` will be installed.

    homebrew_installed_packages:
      - ssh-copy-id
      - pv
      - { name: vim, install_options: "with-luajit,override-system-vi" }

Packages you would like to make sure are installed via `brew install`. You can optionally add flags to the install by setting an `install_options` property, and if used, you need to explicitly set the `name` for the package as well. By default, no packages are installed (`homebrew_installed_packages: []`).

    homebrew_uninstalled_packages: []

Packages you would like to make sure are _uninstalled_.

    homebrew_upgrade_all_packages: false

Whether to upgrade homebrew and all packages installed by homebrew. If you prefer to manually update packages via `brew` commands, leave this set to `false`.

    homebrew_taps:
      - homebrew/core
      - { name: my_company/internal_tap, url: 'https://example.com/path/to/tap.git' }

Set this to your account password if casks you want installed need elevated privileges while installing (like `microsoft-office`), preferably [encrypted via `ansible-vault`][link-vault-doc].

    homebrew_use_brewfile: true

Whether to install via a Brewfile. If so, you will need to install the `homebrew/bundle` tap, which could be done within `homebrew_taps`.

    homebrew_brewfile_dir: '~'

The directory where your Brewfile is located.

    homebrew_clear_cache: false

Set to `true` to remove the Hombrew cache after any new software is installed.

    homebrew_user: "{{ ansible_user_id }}"

The user that you would like to install Homebrew as.

    homebrew_group: "{{ ansible_user_gid }}"

The group that you would like to use while installing Homebrew.

    homebrew_folders_additional: []

Any additional folders inside `homebrew_prefix` for which to ensure homebrew user/group ownership.


## Example Playbook

    - hosts: localhost
      vars:
        homebrew_installed_packages:
          - mysql
      roles:
        - geerlingguy.homebrew

See the `tests/local-testing` directory for an example of running this role over
Ansible's `local` connection. See also:
[Mac Development Ansible Playbook][mac-dev-playbook].

## License

[MIT][link-license]

## Author Information

This role was created in 2014 by [Jeff Geerling][author-website], author of
[Ansible for DevOps][ansible-for-devops].

#### Maintainer(s)

- [Jeff Geerling](https://github.com/geerlingguy)
- [Elliot Weiser](https://github.com/elliotweiser)

[ansible-for-devops]: https://www.ansiblefordevops.com/
[author-website]: https://www.jeffgeerling.com/
[caskroom]: https://caskroom.github.io/search
[homebrew]: http://brew.sh/
[dep-osx-clt-role]: https://galaxy.ansible.com/elliotweiser/osx-command-line-tools/
[link-galaxy]: https://galaxy.ansible.com/geerlingguy/homebrew/
[link-license]: https://raw.githubusercontent.com/geerlingguy/ansible-role-homebrew/master/LICENSE
[link-gh-actions]: https://github.com/geerlingguy/ansible-role-homebrew/actions?query=workflow%3ACI
[mac-dev-playbook]: https://github.com/geerlingguy/mac-dev-playbook
[link-vault-doc]: https://docs.ansible.com/ansible/latest/user_guide/vault.html#creating-encrypted-variables
