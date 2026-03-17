#!/bin/bash

xcode-select --install

if [ ! -d ~/.oh-my-zsh ]; then
   echo "Install zsh first using:"
   echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
   exit
fi

# Terminal theme
THEME_NAME="catppuccin-frappe"  # must match exact name in Terminal.app
if ! plutil -p ~/Library/Preferences/com.apple.Terminal.plist 2>/dev/null | grep -q "$THEME_NAME"; then
    echo "⚠️  Terminal theme '$THEME_NAME' not found."
    echo "Download and install it? [y/N] "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        url="https://raw.githubusercontent.com/catppuccin/Terminal.app/refs/heads/main/themes/catppuccin-frappe.terminal"
        curl -O "$url"
        echo "→ In Terminal: Settings → Profiles → select theme → Default"
        echo "→ Re-open terminal when done."
    fi
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

# Key repeats - repeat the key when holding it
defaults write -g ApplePressAndHoldEnabled -bool false

# Show hidden files and folders
defaults write com.apple.Finder AppleShowAllFiles true

# Change Screenshot default save location
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots

# Screenshot Format: Change from PNG (larger) to JPG
defaults write com.apple.screencapture type jpg

# Software
echo "Installing apps..."
brew install node
brew install ollama
brew install --cask 1password
brew install --cask cursor
brew install --cask maccy
brew install --cask spotify
brew install --cask zed
brew install --cask brave-browser
brew install --cask docker-desktop
brew install --cask nordvpn
brew install --cask stats
brew install --cask claude
brew install --cask iina
brew install --cask rectangle
brew install --cask whatsapp

# Dev Env folder
mkdir -p ~/Projects

# Make IINA the default media player
# Check if duti is installed - duti is used to set default apps for file types
if ! command -v duti &> /dev/null; then
    echo "duti is not installed. Installing it via Homebrew..."
    brew install duti
fi

# Common media UTIs
declare -a MEDIA_EXTENSIONS=(
    # Audio formats
    "mp3"   # MP3 audio
    "wav"   # WAV audio
    "flac"  # FLAC audio
    "aac"   # AAC audio
    "ogg"   # OGG audio
    "opus"  # OPUS audio
    "m4a"   # M4A audio
    "aiff"  # AIFF audio
    "alac"  # ALAC (Apple Lossless Audio Codec)
    "wma"   # Windows Media Audio
    "caf"   # Core Audio Format

    # Video formats
    "mp4"   # MP4 video
    "mkv"   # MKV video
    "avi"   # AVI video
    "mov"   # QuickTime video
    "mpeg"  # MPEG video
    "ogv"   # OGV video
    "webm"  # WEBM video
    "m4v"   # M4V video
    "3gp"   # 3GP video
    "ts"    # MPEG-TS video
    "wmv"   # Windows Media Video
    "flv"   # Flash Video
    "vob"   # DVD Video Object
    "f4v"   # Flash MP4 Video
    "rm"    # RealMedia
    "rmvb"  # RealMedia Variable Bitrate
)

echo "Setting IINA as the default player for supported media files..."
for EXT in "${MEDIA_EXTENSIONS[@]}"; do
    duti -s "com.colliderli.iina" "$EXT" all
done

echo "IINA has been set as the default player for all supported media files."
