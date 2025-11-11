#!/bin/bash
# Module: AI CLI Tools
# Description: AI command-line tools installation functions including Qoder CLI
# Dependencies: lib/common.sh, lib/package-manager.sh, modules/javascript.sh

# Install Claude Code CLI
install_claude_code() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Claude Code CLI kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    echo -e "${YELLOW}[BİLGİ]${NC} Claude Code CLI indiriliyor ve kuruluyor..."
    curl -L https://github.com/anthropics/claude-code/releases/latest/download/installer.sh | bash

    reload_shell_configs

    if command -v claude-code &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} Claude Code CLI kurulumu tamamlandı!"
    else
        echo -e "${RED}[HATA]${NC} Claude Code CLI kurulumu başarısız!"
        return 1
    fi
}

# Install Gemini CLI
install_gemini_cli() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Gemini CLI kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}[UYARI]${NC} Python kurulu değil. Önce Python kuruluyor..."
        install_python
    fi

    echo -e "${YELLOW}[BİLGİ]${NC} Google AI Python SDK kuruluyor..."
    python3 -m pip install google-generativeai --break-system-packages 2>/dev/null || \
    python3 -m pip install google-generativeai

    echo -e "${GREEN}[BAŞARILI]${NC} Gemini CLI için Google AI SDK kuruldu!"
}

# Install OpenCode CLI
install_opencode_cli() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} OpenCode CLI kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if ! command -v npm &> /dev/null; then
        echo -e "${YELLOW}[UYARI]${NC} NPM kurulu değil. NVM ile Node.js kuruluyor..."
        install_nvm
    fi

    echo -e "${YELLOW}[BİLGİ]${NC} OpenCode CLI npm ile kuruluyor..."
    npm install -g opencode-cli

    reload_shell_configs

    if command -v opencode &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} OpenCode CLI kurulumu tamamlandı!"
    else
        echo -e "${RED}[HATA]${NC} OpenCode CLI kurulumu başarısız!"
        return 1
    fi
}

# Install Qwen CLI
install_qwen_cli() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Qwen CLI kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if ! command -v pipx &> /dev/null; then
        echo -e "${YELLOW}[UYARI]${NC} Pipx kurulu değil. Önce pipx kuruluyor..."
        install_pipx
    fi

    echo -e "${YELLOW}[BİLGİ]${NC} Qwen CLI pipx ile kuruluyor..."
    pipx install qwen-cli

    reload_shell_configs

    if command -v qwen &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} Qwen CLI kurulumu tamamlandı!"
    else
        echo -e "${RED}[HATA]${NC} Qwen CLI kurulumu başarısız!"
        return 1
    fi
}

# Install Copilot CLI
install_copilot_cli() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} GitHub Copilot CLI kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if ! command -v npm &> /dev/null; then
        echo -e "${YELLOW}[UYARI]${NC} NPM kurulu değil. NVM ile Node.js kuruluyor..."
        install_nvm
    fi

    echo -e "${YELLOW}[BİLGİ]${NC} GitHub Copilot CLI npm ile kuruluyor..."
    npm install -g @githubnext/github-copilot-cli

    reload_shell_configs

    echo -e "${GREEN}[BAŞARILI]${NC} GitHub Copilot CLI kurulumu tamamlandı!"
    echo -e "\n${CYAN}[BİLGİ]${NC} GitHub hesabınızla oturum açmak için:"
    echo -e "  ${GREEN}github-copilot-cli auth${NC}"
}

# Install GitHub CLI
install_github_cli() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} GitHub CLI kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if [ "$PKG_MANAGER" = "apt" ]; then
        echo -e "${YELLOW}[BİLGİ]${NC} GitHub GPG key ekleniyor..."
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        eval "$INSTALL_CMD" gh

    elif [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ]; then
        sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        eval "$INSTALL_CMD" gh

    elif [ "$PKG_MANAGER" = "pacman" ]; then
        eval "$INSTALL_CMD" github-cli
    fi

    if command -v gh &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} GitHub CLI kurulumu tamamlandı: $(gh --version)"
        echo -e "\n${CYAN}[BİLGİ]${NC} GitHub hesabınızla oturum açmak için:"
        echo -e "  ${GREEN}gh auth login${NC}"
    else
        echo -e "${RED}[HATA]${NC} GitHub CLI kurulumu başarısız!"
        return 1
    fi
}

# AI CLI Tools installation menu
install_ai_cli_tools_menu() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         AI CLI Araçları Kurulumu              ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
    echo -e "  ${CYAN}1${NC}) Claude Code CLI"
    echo -e "  ${CYAN}2${NC}) Gemini CLI"
    echo -e "  ${CYAN}3${NC}) OpenCode CLI"
    echo -e "  ${CYAN}4${NC}) Qwen CLI"
    echo -e "  ${CYAN}5${NC}) GitHub Copilot CLI"
    echo -e "  ${CYAN}6${NC}) GitHub CLI"
    echo -e "  ${CYAN}7${NC}) Qoder CLI"
    echo -e "  ${CYAN}8${NC}) Tümünü Kur"
    echo -e "  ${CYAN}9${NC}) Ana menüye dön"

    echo -ne "\n${YELLOW}Seçiminizi yapın (1-9): ${NC}"
    read -r choice

    case $choice in
        1) install_claude_code ;;
        2) install_gemini_cli ;;
        3) install_opencode_cli ;;
        4) install_qwen_cli ;;
        5) install_copilot_cli ;;
        6) install_github_cli ;;
        7) install_qoder_cli ;;
        8)
            install_claude_code
            install_gemini_cli
            install_opencode_cli
            install_qwen_cli
            install_copilot_cli
            install_github_cli
            install_qoder_cli
            ;;
        9) return ;;
        *) echo -e "${RED}[HATA]${NC} Geçersiz seçim!" ;;
    esac
}

# Install Qoder CLI
install_qoder_cli() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Qoder CLI kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    echo -e "${YELLOW}[BİLGİ]${NC} Qoder CLI indiriliyor ve kuruluyor..."
    curl -fsSL https://qoder.com/install | bash

    reload_shell_configs

    if command -v qoder &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} Qoder CLI kurulumu tamamlandı!"
    else
        echo -e "${RED}[HATA]${NC} Qoder CLI kurulumu başarısız!"
        return 1
    fi
}
# Export functions for use in other modules
export -f install_qoder_cli
export -f install_claude_code
export -f install_gemini_cli
export -f install_opencode_cli
export -f install_qwen_cli
export -f install_copilot_cli
export -f install_github_cli
export -f install_ai_cli_tools_menu
