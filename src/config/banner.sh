#!/bin/bash
# Banner and ASCII Art Configuration
# This file contains the script banner and header display functions

# Function to display the banner
show_banner() {
    clear

    # 1453 ASCII Art
    echo -e "${CYAN}"
    echo '   /$$ /$$   /$$ /$$$$$$$   /$$$$$$ '
    echo ' /$$$$| $$  | $$| $$____/  /$$__  $$'
    echo '|_  $$| $$  | $$| $$      |__/  \ $$'
    echo '  | $$| $$$$$$$$| $$$$$$$    /$$$$$$/'
    echo '  | $$|_____  $$|_____  $$  |___  $$'
    echo '  | $$      | $$ /$$  \ $$ /$$  \ $$'
    echo ' /$$$$$$    | $$|  $$$$$$/|  $$$$$$/'
    echo '|______/    |__/ \______/  \______/ '
    echo -e "${NC}"
    echo ""

    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   1453.AI - WSL Vibe Coder'lar İçin Otomatik Kurulum Rehberi   ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}\n"

    # Script Information
    echo -e "${YELLOW}Script Sürümü:${NC} v2.0 Modular"
    echo -e "${YELLOW}GitHub:${NC} https://github.com/1453h/wsl-bash-script"
    echo -e "${YELLOW}Tarih:${NC} $(date '+%Y-%m-%d %H:%M:%S')\n"
}

# Export the function so it's available to other modules
export -f show_banner