#!/bin/bash

xcode-select --install

if [ ! -d ~/.oh-my-zsh ]; then
   echo "Install zsh first using:"
   echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
   exit
fi

# git && ssh Key setup
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY_PATH" ]; then
   echo "Setting up git & ssh..."
   echo "What is your email?"
   read email
   echo "And your full name?"
   read name

   mkdir -p "$HOME/.ssh"
   ssh-keygen -t ed25519 -f $SSH_KEY_PATH -N "" -C $email
   ssh-add -K $SSH_KEY_PATH

   git config --global user.email $email
   git config --global user.name $name
fi

# Git
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.cm "\!git add -A && git commit -m"
git config --global alias.wip "commit -am 'wip'"
git config --global alias.save "\!git add -A && git commit -m 'SAVEPOINT'"
git config --global alias.undo "reset HEAD~1 --mixed"

git config pull.rebase false # make merge the default pull behaviour
git config --global pager.branch false # Make git branch behave like it should

# Install homebrew
if [ ! -f "/opt/homebrew/bin/brew" ]; then
   echo "Installing Homebrew"
   
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
   echo "Homebrew already installed, moving on..."
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Command Line configs (zsh)
if grep -Fxq "# mac setup script" ~/.zshrc
then
   echo ".zshrc already setup, moving on..."
else
   echo "setting up zsh config"

   echo "" >> ~/.zshrc
   echo "# mac setup script" >> ~/.zshrc
   echo "echo \"Hello $name\"" >> ~/.zshrc

   # brew setup
   echo "" >> ~/.zshrc
   echo "# brew" >> ~/.zshrc
   echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zshrc

   # docker aliases
   echo "" >> ~/.zshrc
   echo '# Docker Aliases'                         >> ~/.zshrc
   echo 'alias dc="docker compose"'                >> ~/.zshrc # Alias dc = docker compose
   echo 'dps() { docker ps }'                      >> ~/.zshrc # List all running containers
   echo 'dsa() { docker stop $(docker ps -a -q) }' >> ~/.zshrc # Stop all running containers
   echo 'dka() { docker kill $(docker ps -q) }'    >> ~/.zshrc # Kill all running containers
   echo 'dra() { docker rm $(docker ps -a -q) }'   >> ~/.zshrc # Remove all containers
   echo 'dsh() { docker exec -it $1 /bin/sh }'     >> ~/.zshrc # sh into container with id
   echo 'dbash() { docker exec -it $1 /bin/bash }' >> ~/.zshrc # bash into container with id
   echo 'drc() {docker exec -it $1 rails c}'       >> ~/.zshrc # rails console into container with id
fi

# Keyboard repeat speed
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Show hidden files and folders
defaults write com.apple.Finder AppleShowAllFiles true

# Software
echo "Installing apps..."
brew install --cask 1password
brew install --cask sublime-text
brew install --cask google-chrome      # Browser for work stuff
brew install --cask brave-browser      # Browser for personal stuff
brew install --cask docker
brew install --cask whatsapp
brew install --cask spotify
brew install --cask discord
brew install --cask visual-studio-code
brew install --cask rectangle 		   # Window manager
brew install --cask iterm2             # Good ol' iterm2 - considering changing to warp
brew install --cask warp			      # Modern Terminal
brew install --cask container-ps	      # Docker manager
brew install --cask maccy			      # Clipboard manager
brew install --cask raycast			   # Spotlight alternative


# Dev Env
mkdir -p ~/Projects
