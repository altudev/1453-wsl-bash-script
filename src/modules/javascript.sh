#!/bin/bash
# Module: JavaScript Ecosystem
# Description: NVM and Bun.js installation functions
# Dependencies: lib/common.sh

# Install NVM (Node Version Manager)
install_nvm() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} NVM kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    # Download and install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    # Set up NVM directory
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Update shell RC files
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        if [ -f "$rc_file" ]; then
            if ! grep -q 'NVM_DIR' "$rc_file"; then
                echo -e "${YELLOW}[BİLGİ]${NC} NVM $rc_file dosyasına ekleniyor..."
                echo '' >> "$rc_file"
                echo "export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\"" >> "$rc_file"
                echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"" >> "$rc_file"
            fi
        fi
    done

    # Load NVM again to ensure it's available
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo -e "${YELLOW}[BİLGİ]${NC} Node.js LTS sürümü kuruluyor..."
    nvm install --lts
    nvm use --lts

    echo -e "\n${GREEN}[BAŞARILI]${NC} Node.js sürümü: $(node -v)"
    echo -e "${GREEN}[BAŞARILI]${NC} NPM sürümü: $(npm -v)"
}

# Install Bun.js
install_bun() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Bun.js kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    echo -e "${YELLOW}[BİLGİ]${NC} Bun.js (curl) ile kuruluyor..."
    curl -fsSL https://bun.sh/install | bash

    # Set up Bun environment
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # Update shell RC files
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        if [ -f "$rc_file" ]; then
            if ! grep -q '.bun/bin' "$rc_file"; then
                echo '' >> "$rc_file"
                echo '# Bun.js PATH' >> "$rc_file"
                echo "export BUN_INSTALL=\"\$HOME/.bun\"" >> "$rc_file"
                echo "export PATH=\"\$BUN_INSTALL/bin:\$PATH\"" >> "$rc_file"
            fi
        fi
    done

    reload_shell_configs

    if command -v bun &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} Bun.js kurulumu tamamlandı: $(bun --version)"
        echo -e "\n${CYAN}[BİLGİ]${NC} Bun.js Kullanım İpuçları:"
        echo -e "  ${GREEN}•${NC} Proje başlatma: ${GREEN}bun init${NC}"
        echo -e "  ${GREEN}•${NC} Paket kurma: ${GREEN}bun add paket_adi${NC}"
        echo -e "  ${GREEN}•${NC} Script çalıştırma: ${GREEN}bun run start${NC}"
        echo -e "  ${GREEN}•${NC} Güncelleme: ${GREEN}bun upgrade${NC}"
    else
        echo -e "${RED}[HATA]${NC} Bun.js kurulumu başarısız!"
        return 1
    fi
}

# Export functions for use in other modules
export -f install_nvm
export -f install_bun