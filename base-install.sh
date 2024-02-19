#!/usr/bin/bash

main() {
  update_package_lists
  install_zsh
  install_lsd
  install_nvim
  install_starship
  install_git #installs updated version of git.
  install_nix

  # If the no-docker argument is not passed, install Docker.
  if [ "$1" != "no-docker" ]; then
    install_docker
  fi
  
  # install_build_essentials
  sudo apt-get install build-essential -y
}

# Update package lists
update_package_lists() {
  sudo apt-get update -y
}

# Check to see if an app is already installed on the system. 
is_installed() {
  app_name=$1

  if which $app_name &> /dev/null; then
    echo true
  else
    echo false
  fi
}

# Install Zsh.
# https://www.zsh.org/
install_zsh() {
  if $(is_installed zsh); then
    echo "Zsh is already installed"
    return 0
  fi

  sudo apt install zsh -y
  # Sets Zsh as the default shell.
  # chsh -s /usr/bin/zsh
}

# Install LSD (LSDeluxe) ls replacement.
# https://github.com/lsd-rs/lsd
install_lsd() {
  if $(is_installed lsd); then
    echo "LSD is already installed"
    return 0
  fi

  echo "Installing LSD..."
  wget https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz
  tar -xzf lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz
  sudo mv lsd-v1.0.0-x86_64-unknown-linux-gnu/lsd /usr/bin/
  sudo chown root:root /usr/bin/lsd
  rm -rf lsd-v1.0.0-x86_64-unknown-linux-gnu
  rm lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz
}

# Install Starship (Custom Prompt)
# https://starship.rs/
install_starship() {
  if $(is_installed starship); then
    echo "Starship is already installed"
    return 0
  fi

  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

# Install Neovim.
# https://neovim.io/
install_nvim() {
  if $(is_installed nvim); then
    echo "Neovim is already installed"
    return 0
  fi
  
  echo "Installing Neovim..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  rm nvim-linux64.tar.gz

}

install_docker() {
  if $(is_installed docker); then
    echo "Docker is already installed"
    return 0
  fi

  echo "Installing Docker..."

  # Uninstall conflicting packages.
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

  # Add Docker's official GPG key.
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the Docker repository to apt sources.
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Install the Docker packages
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

  # Allow user to administer docker
  sudo groupadd docker  
  sudo usermod -aG docker $USER
}

install_git() {
  sudo add-apt-repository ppa:git-core/ppa -y
  sudo apt update -y
  sudo apt install git -y
}

install_nix() {
  sudo curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
  sudo sh -c 'echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf'
}

# Run the main function when the script runs.
main
