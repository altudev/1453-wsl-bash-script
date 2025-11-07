# WSL Development Environment Setup Script

This script automates the setup of a complete development environment on a fresh Ubuntu WSL installation. It installs a comprehensive set of tools and packages essential for modern web and software development.

## Features

The script will install the following tools:

- **System Tools**: `curl`, `jq`, `unzip`, `tar`, `git`
- **GitHub CLI**: `gh`
- **Python**: `python3`, `pip`, `pipx`, `uv`
- **Node.js**: `nvm` (Node Version Manager), with a configurable version (defaults to LTS).
- **JavaScript Runtimes & Package Managers**: `bun`, `pnpm`, `yarn`
- **Go**: Configurable version of the Go programming language.

## Configuration

You can customize the versions of the tools to be installed by editing the `src/ubuntu/config.sh` file.

Open the file and modify the version variables as needed:

```bash
# src/ubuntu/config.sh

# Node.js version (e.g., "lts", "latest", "18", "20.11.0")
NODE_VERSION="lts"

# Go version (e.g., "1.22.0").
GO_VERSION="1.22.0"
```

## Prerequisites

- A fresh installation of Ubuntu on WSL (Windows Subsystem for Linux).
- `sudo` privileges for the user running the script.

## Getting Started

1.  **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd 1453-wsl-script
    ```

2.  **Run the installation script:**

    Navigate to the script directory and execute it:

    ```bash
    cd src/ubuntu
    ./install.sh
    ```

    The script will prompt for your password to install packages using `sudo`.

3.  **Restart your shell:**

    After the script completes, it is crucial to restart your shell session or run the following command for all changes to take effect:

    ```bash
    source ~/.bashrc
    ```

## How it Works

The script performs the following actions:

1.  **Updates System Packages**: It runs `sudo apt-get update` and `sudo apt-get upgrade` to ensure all system packages are up to date.
2.  **Installs Essential Tools**: It installs a set of fundamental command-line utilities.
3.  **Installs Language Runtimes and Tools**: It systematically installs Python, Node.js (via nvm), and Go, along with their respective package managers and related tools.
4.  **Sets up Environment**: It modifies the `.bashrc` file to include necessary paths for `nvm` and `go`.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.