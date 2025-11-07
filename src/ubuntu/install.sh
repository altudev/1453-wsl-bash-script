#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Source the configuration file
. "$(dirname "$0")/config.sh"


# Update and upgrade system packages
echo "Updating and upgrading system packages..."
sudo apt-get update
sudo apt-get upgrade -y
echo "System packages updated and upgraded."

# Install essential tools
echo "Installing essential tools: curl, jq, unzip, tar, git..."
sudo apt-get install -y curl jq unzip tar git
echo "Essential tools installed."

# Install GitHub CLI (gh)
echo "Installing GitHub CLI..."
if ! command -v gh &> /dev/null
then
    type -p curl >/dev/null || (sudo apt-get update && sudo apt-get install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-key.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-key.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-key.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-key.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt-get update \
    && sudo apt-get install gh -y
    echo "GitHub CLI installed."
else
    echo "GitHub CLI is already installed."
fi

# Install Python, pip, pipx, and uv
echo "Installing Python, pip, pipx, and uv..."
sudo apt-get install -y python3 python3-pip python3-venv
sudo apt-get install -y pipx
pipx ensurepath
pipx install uv
echo "Python, pip, pipx, and uv installed."

# Install nvm, Node.js, and related tools
echo "Installing nvm, Node.js, Bun, pnpm, and yarn..."
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install "${NODE_VERSION}"
nvm use "${NODE_VERSION}"

# Install Bun
curl -fsSL https://bun.sh/install | bash

# Install pnpm and yarn
npm install -g pnpm yarn
echo "nvm, Node.js, Bun, pnpm, and yarn installed."

# Install Go
echo "Installing Go..."
if ! command -v go &> /dev/null
then
    echo "Installing Go version ${GO_VERSION}..."
    wget "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm "go${GO_VERSION}.linux-amd64.tar.gz"
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo "Go installed. Please restart your shell or run 'source ~/.bashrc' to use it."
else
    echo "Go is already installed."
fi

echo "Development environment setup complete!"
echo "Please restart your shell or run 'source ~/.bashrc' for all changes to take effect."
