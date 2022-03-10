#!/bin/sh

echo "Symlinking dotfiles..."
stow -v -d ~/dotfiles/packages -t ~ karabiner nvim git p10k