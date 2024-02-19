#!/usr/bin/bash

git clone --bare https://github.com/jeremytondo/dotfiles.git .dotfiles

# alias config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# config checkout

git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

cd /root/.config

./install
