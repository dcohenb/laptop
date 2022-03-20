#!/bin/bash

# User name and email for git config
echo "What is your email?"
read email
echo "And your full name?"
read name

# 
sudo apt-get -y update
sudo apt-get -y install zsh nodejs unzip

# Allow case insensitive tab completion
if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
echo 'set completion-ignore-case On' >> ~/.inputrc

# Setup SSH Keys
ssh-keygen -t ed25519 -C $email
echo "Add this public key to your github account at: https://github.com/settings/keys"
cat ~/.ssh/id_ed25519.pub
eval `ssh-agent -s`
ssh-add ~/.ssh/id_ed25519

# Git Setup
git config --global user.email $email
git config --global user.name $name
git config --global alias.st status
git config --global alias.co checkout
git config --global core.autocrlf true # Fixes issues around line endings
echo 'alias grh="git fetch && git reset --hard"' >> ~/.zshrc

# Zsh install and setup
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git config --global oh-my-zsh.hide-info 1

# Docker Compose

# Docker machine
sudo curl -L "https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-machine
sudo chmod +x /usr/local/bin/docker-machine

# Docker aliases
echo '# Docker Aliases' >> ~/.zshrc
echo 'alias dc=docker-compose' >> ~/.zshrc					# Alias dc = docker-compose
echo 'dps() { docker ps }' >> ~/.zshrc						# List all running containers
echo 'dsa() { docker stop $(docker ps -a -q) }' >> ~/.zshrc	# Stop all running containers
echo 'dka() { docker kill $(docker ps -q) }' >> ~/.zshrc	# Kill all running containers
echo 'dra() { docker rm $(docker ps -a -q) }' >> ~/.zshrc	# Remove all containers
echo 'dsh() { docker exec -it $1 /bin/sh }' >> ~/.zshrc		# sh into container with id
echo 'dbash() { docker exec -it $1 /bin/bash }' >> ~/.zshrc	# bash into container with id
echo 'drc() {docker exec -it $1 rails c}' >> ~/.zshrc		# rails console into container with id
