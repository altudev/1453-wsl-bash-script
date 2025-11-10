#!/bin/bash
# Module: Interactive Menus
# Description: Main menu system and user interaction
# Dependencies: All other modules

# Configure Git
configure_git() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Git yapılandırması başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    echo -ne "${YELLOW}Git kullanıcı adınızı girin: ${NC}"
    read -r git_user
    echo -ne "${YELLOW}Git e-posta adresinizi girin: ${NC}"
    read -r git_email

    git config --global user.name "$git_user"
    git config --global user.email "$git_email"

    echo -e "${GREEN}[BAŞARILI]${NC} Git yapılandırması tamamlandı!"
    echo -e "  Kullanıcı: $git_user"
    echo -e "  E-posta: $git_email"
}

# Prepare and configure Git
prepare_and_configure_git() {
    update_system
    configure_git
}

# Display main menu
show_menu() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    Ana Kurulum Menüsü                          ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "  ${GREEN}1${NC}) Tam Kurulum (Önerilen)"
    echo -e "  ${GREEN}2${NC}) Hazırlık (Sistem güncelleme + Git)"
    echo -e "  ${GREEN}3${NC}) Python Kurulumu"
    echo -e "  ${GREEN}4${NC}) Pip Güncelleme"
    echo -e "  ${GREEN}5${NC}) Pipx Kurulumu"
    echo -e "  ${GREEN}6${NC}) UV Kurulumu"
    echo -e "  ${GREEN}7${NC}) NVM Kurulumu"
    echo -e "  ${GREEN}8${NC}) Bun.js Kurulumu"
    echo -e "  ${GREEN}9${NC}) PHP Kurulumu"
    echo -e "  ${GREEN}10${NC}) Composer Kurulumu"
    echo -e "  ${GREEN}11${NC}) AI CLI Araçları"
    echo -e "  ${GREEN}12${NC}) AI Framework'leri"
    echo -e "  ${GREEN}13${NC}) AI Framework'leri Kaldır"
    echo -e "  ${GREEN}0${NC}) Çıkış"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}"
}

# Main program loop
main() {
    # Detect package manager on startup
    detect_package_manager

    # Track installed components
    local NVM_INSTALLED=false
    local PYTHON_INSTALLED=false

    while true; do
        show_menu
        echo -ne "\n${YELLOW}Seçiminizi yapın (virgülle ayırarak birden fazla seçebilirsiniz): ${NC}"
        read -r choices

        # Convert choices to array
        IFS=',' read -ra choice_array <<< "$choices"

        for choice in "${choice_array[@]}"; do
            # Trim whitespace
            choice=$(echo "$choice" | xargs)

            case $choice in
                1)
                    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
                    echo -e "${BLUE}║           TAM KURULUM BAŞLATILIYOR            ║${NC}"
                    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
                    update_system
                    configure_git
                    install_python && PYTHON_INSTALLED=true
                    install_pip
                    install_pipx
                    install_uv
                    install_nvm && NVM_INSTALLED=true
                    install_bun
                    install_composer
                    install_claude_code
                    install_github_cli
                    echo -e "\n${GREEN}[BAŞARILI]${NC} Tam kurulum tamamlandı!"
                    ;;
                2) prepare_and_configure_git ;;
                3) install_python && PYTHON_INSTALLED=true ;;
                4) install_pip ;;
                5) install_pipx ;;
                6) install_uv ;;
                7) install_nvm && NVM_INSTALLED=true ;;
                8) install_bun ;;
                9) install_php_version_menu ;;
                10) install_composer ;;
                11) install_ai_cli_tools_menu ;;
                12) install_ai_frameworks_menu ;;
                13) remove_ai_frameworks_menu ;;
                0)
                    echo -e "\n${GREEN}[BİLGİ]${NC} Kurulum scripti sonlandırılıyor..."
                    echo -e "${YELLOW}[İPUCU]${NC} Yeni kurulumların aktif olması için terminali yeniden başlatın!"
                    exit 0
                    ;;
                *)
                    echo -e "${RED}[HATA]${NC} Geçersiz seçim: $choice"
                    ;;
            esac
        done

        # Check if critical tools were installed
        if [ "$NVM_INSTALLED" = true ] || [ "$PYTHON_INSTALLED" = true ]; then
            echo -e "\n${YELLOW}[ÖNEMLİ]${NC} Yeni kurulumlar tespit edildi."
            echo -e "${CYAN}[İPUCU]${NC} Değişikliklerin aktif olması için:"
            echo -e "  1) ${GREEN}source ~/.bashrc${NC} veya ${GREEN}source ~/.zshrc${NC} komutunu çalıştırın"
            echo -e "  2) Ya da terminali yeniden başlatın"
        fi

        echo -e "\n${YELLOW}Devam etmek için Enter'a basın...${NC}"
        read -r
    done
}

# Export functions for use in other modules
export -f configure_git
export -f prepare_and_configure_git
export -f show_menu
export -f main