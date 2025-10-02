#!/usr/bin/env bash
set -e

echo "🚀 Starting Ubuntu Dev Environment Setup for Rapha..."

# ---------------------------
# Basic Tools
# ---------------------------
echo "🛠️ Installing Git, Curl, and build tools..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget build-essential

# Install a base Node.js + npm so npm works (will replace later with nvm LTS)
echo "📦 Installing temporary Node.js & npm..."
sudo apt install -y nodejs npm

# ---------------------------
# Docker & Docker Compose
# ---------------------------
echo "🐳 Installing Docker and Docker Compose..."
sudo apt-get remove docker docker-engine docker.io containerd runc -y || true
sudo apt-get install \
    ca-certificates \
    gnupg \
    lsb-release -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Enable docker without sudo
sudo groupadd docker || true
sudo usermod -aG docker $USER

# ---------------------------
# VSCode
# ---------------------------
echo "📝 Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm microsoft.gpg
sudo apt update
sudo apt install code -y

# ---------------------------
# Yarn
# ---------------------------
echo "📦 Installing Yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn -y

# ---------------------------
# Zsh & Oh-My-Zsh
# ---------------------------
echo "💻 Installing Zsh and Oh-My-Zsh..."
sudo apt install zsh -y
chsh -s $(which zsh)

# Install Oh-My-Zsh unattended
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ---------------------------
# NVM & Node.js (latest LTS)
# ---------------------------
echo "📦 Installing NVM and Node.js LTS..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
nvm alias default lts/*

# ---------------------------
# Postman
# ---------------------------
echo "📮 Installing Postman..."
sudo snap install postman

# ---------------------------
# DBeaver
# ---------------------------
echo "🗄️ Installing DBeaver..."
sudo snap install dbeaver-ce

# ---------------------------
# Flameshot
# ---------------------------
echo "📸 Installing Flameshot..."
sudo apt install flameshot -y

echo "✅ Setup complete! Please restart your terminal or run 'exec zsh'."
echo "🚨 NOTE: You may need to log out and back in for Docker group changes to apply."
