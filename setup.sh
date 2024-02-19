#!/usr/bin/bash

sudo curl -sS https://raw.githubusercontent.com/jeremytondo/workstation-setup/main/base-install.sh | bash

git clone --bare https://github.com/jeremytondo/dotfiles.git .dotfiles

git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

cd .config

./install
