#!/bin/bash

# 1453.AI WSL Vibe Coder'lar İçin Otomatik Kurulum Scripti
# Version: 2.0 - Modular Architecture
# GitHub: https://github.com/1453h/wsl-bash-script

# Get the directory where this script resides
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Phase 1: Critical initialization (CRLF must run first)
# shellcheck source=lib/init.sh
source "${SCRIPT_DIR}/lib/init.sh"

# Phase 2: Load configurations
# shellcheck source=config/colors.sh
source "${SCRIPT_DIR}/config/colors.sh"

# shellcheck source=config/php-versions.sh
source "${SCRIPT_DIR}/config/php-versions.sh"

# shellcheck source=config/banner.sh
source "${SCRIPT_DIR}/config/banner.sh"

# Phase 3: Load core libraries
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

# shellcheck source=lib/package-manager.sh
source "${SCRIPT_DIR}/lib/package-manager.sh"

# Phase 4: Load feature modules
# shellcheck source=modules/python.sh
source "${SCRIPT_DIR}/modules/python.sh"

# shellcheck source=modules/javascript.sh
source "${SCRIPT_DIR}/modules/javascript.sh"

# shellcheck source=modules/php.sh
source "${SCRIPT_DIR}/modules/php.sh"

# shellcheck source=modules/ai-cli.sh
source "${SCRIPT_DIR}/modules/ai-cli.sh"

# shellcheck source=modules/ai-frameworks.sh
source "${SCRIPT_DIR}/modules/ai-frameworks.sh"

# shellcheck source=modules/menus.sh
source "${SCRIPT_DIR}/modules/menus.sh"

# Phase 5: Display banner and run main program
show_banner
main "$@"