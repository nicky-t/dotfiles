#!/bin/sh
set -e

cd ~

# Install Homebrew
if [ ! -f /opt/homebrew/bin/brew ]
  then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already installed."
fi

# Install some software brew
echo "Installing some software & library..."
brew bundle -v --file=./dotfiles/Brewfile
echo "--------------------------------------------------------"

echo "シンボリックリンクを貼る"
echo "Symlinking dotfiles..."
~/dotfiles/shell/symlink.sh
echo "zshrc symlink"
ln -sf ~/dotfiles/packages/zsh/.zshrc ~/.zshrc
echo "zprofile symlink"
ln -sf ~/dotfiles/packages/zsh/.zprofile ~/.zprofile
echo "zsh_history symlink"
ln -sf ~/dotfiles/packages/zsh/.zsh_history ~/.zsh_history
echo "Done."
exec zsh
