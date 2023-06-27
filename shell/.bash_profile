# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT ]]; then
  SCRIPT_PATH=$(readlink -n -f $CURRENT_SCRIPT)
  DOTFILES_DIR="$(dirname $(dirname $SCRIPT_PATH))"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/shell/bin:$PATH"

# Get homebrew prefix can be either linuxbrew or homebrew atm)
PATH="/opt/homebrew/bin:$PATH"
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

HOMEBREW_PREFIX=$(brew --prefix)

# Source the dotfiles (order matters)

for DOTFILE in $HOME/.config/bash/.{function,function_*,path,environment,alias,bash_completions,thefuck,fzf,fnm,grep,direnv,starship,zoxide,bun_completions}; do
  . "$DOTFILE"
done

if is-linux; then
  for DOTFILE in $HOME/.config/bash/.{homebrew,micromamba}.linux; do
    . "$DOTFILE"
  done
fi

if is-macos; then
  for DOTFILE in $HOME/.config/bash/.{function,environment,alias,micromamba}.macos; do
    . "$DOTFILE"
  done
fi

# Clean up

unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# Export

export DOTFILES_DIR
