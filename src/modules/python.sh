#!/bin/bash
# Module: Python Ecosystem
# Description: Python, pip, pipx, and uv installation functions
# Dependencies: lib/common.sh, lib/package-manager.sh

# Install Python3
install_python() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Python kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} Python zaten kurulu: $(python3 --version)"
        return 0
    fi

    echo -e "${YELLOW}[BİLGİ]${NC} Python3 kuruluyor..."
    eval "$INSTALL_CMD" python3 python3-pip python3-venv

    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} Python kurulumu tamamlandı: $(python3 --version)"
    else
        echo -e "${RED}[HATA]${NC} Python kurulumu başarısız!"
        return 1
    fi
}

# Install/update pip
install_pip() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Pip kurulumu/güncelleme başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}[UYARI]${NC} Python kurulu değil, önce Python kuruluyor..."
        install_python
    fi

    echo -e "${YELLOW}[BİLGİ]${NC} Pip güncelleniyor..."

    # Handle PEP 668 externally-managed-environment error
    if python3 -m pip install --upgrade pip 2>&1 | grep -q "externally-managed-environment"; then
        echo -e "${YELLOW}[BİLGİ]${NC} Externally-managed-environment hatası, --break-system-packages ile deneniyor..."
        python3 -m pip install --upgrade pip --break-system-packages
    else
        python3 -m pip install --upgrade pip
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[BAŞARILI]${NC} Pip sürümü: $(python3 -m pip --version)"
        echo -e "\n${CYAN}[BİLGİ]${NC} Pip Kullanım İpuçları:"
        echo -e "  ${GREEN}•${NC} Paket kurma: ${GREEN}pip install paket_adi${NC}"
        echo -e "  ${GREEN}•${NC} Sanal ortamda kurma (önerilen): ${GREEN}python3 -m venv myenv && source myenv/bin/activate${NC}"
        echo -e "  ${GREEN}•${NC} Sistem geneli kurma: ${GREEN}pip install --break-system-packages paket_adi${NC}"
        echo -e "  ${YELLOW}•${NC} Not: Modern sistemlerde sanal ortam kullanımı önerilir (PEP 668)"
    else
        echo -e "${RED}[HATA]${NC} Pip güncellemesi başarısız!"
        return 1
    fi
}

# Install pipx
install_pipx() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} Pipx kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}[UYARI]${NC} Python kurulu değil, önce Python kuruluyor..."
        install_python
    fi

    echo -e "${YELLOW}[BİLGİ]${NC} Sistem paket yöneticisi ile pipx kuruluyor..."

    # Try installing pipx using the system package manager
    if [ "$PKG_MANAGER" = "apt" ]; then
        eval "$INSTALL_CMD" pipx
    elif [ "$PKG_MANAGER" = "dnf" ]; then
        eval "$INSTALL_CMD" pipx
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        eval "$INSTALL_CMD" python-pipx
    elif [ "$PKG_MANAGER" = "yum" ]; then
        eval "$INSTALL_CMD" pipx
    fi

    # If system package manager failed, try manual installation
    if ! command -v pipx &> /dev/null; then
        echo -e "${YELLOW}[BİLGİ]${NC} Sistem paketi bulunamadı, manuel kurulum yapılıyor..."

        # Handle PEP 668 externally-managed-environment error
        if python3 -m pip install --user pipx 2>&1 | grep -q "externally-managed-environment"; then
            echo -e "${YELLOW}[BİLGİ]${NC} Externally-managed-environment hatası, alternatif yöntem deneniyor..."

            # Use temporary venv for installation
            TEMP_VENV="/tmp/pipx_install_venv"
            rm -rf "$TEMP_VENV"
            python3 -m venv "$TEMP_VENV"

            "$TEMP_VENV/bin/pip" install pipx

            # Copy pipx to user's local bin
            mkdir -p "$HOME/.local/bin"
            cp "$TEMP_VENV/bin/pipx" "$HOME/.local/bin/"

            mkdir -p "$HOME/.local/pipx"
            cp -r "$TEMP_VENV/lib/python"*"/site-packages/pipx" "$HOME/.local/pipx/" 2>/dev/null || true

            rm -rf "$TEMP_VENV"

            # If still not available, try with break-system-packages
            if ! command -v pipx &> /dev/null; then
                echo -e "${YELLOW}[UYARI]${NC} --break-system-packages ile kurulum deneniyor..."
                python3 -m pip install --user --break-system-packages pipx
            fi
        else
            python3 -m pip install --user pipx
        fi

        # Ensure pipx path
        if command -v pipx &> /dev/null; then
            python3 -m pipx ensurepath 2>/dev/null || pipx ensurepath 2>/dev/null || true
        fi
    fi

    # Add to PATH
    export PATH="$HOME/.local/bin:$PATH"

    # Update shell RC files
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        if [ -f "$rc_file" ]; then
            if ! grep -q '.local/bin' "$rc_file"; then
                echo '' >> "$rc_file"
                echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "$rc_file"
            fi
        fi
    done

    reload_shell_configs

    if command -v pipx &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} Pipx kurulumu tamamlandı: $(pipx --version 2>/dev/null || echo 'kuruldu')"
        echo -e "\n${CYAN}[BİLGİ]${NC} Pipx Kullanım İpuçları:"
        echo -e "  ${GREEN}•${NC} Paket kurma: ${GREEN}pipx install paket_adi${NC}"
        echo -e "  ${GREEN}•${NC} Paket listesi: ${GREEN}pipx list${NC}"
        echo -e "  ${GREEN}•${NC} Paket kaldırma: ${GREEN}pipx uninstall paket_adi${NC}"
        echo -e "  ${GREEN}•${NC} Tüm paketleri güncelle: ${GREEN}pipx upgrade-all${NC}"
    else
        echo -e "${RED}[HATA]${NC} Pipx kurulumu başarısız!"
        echo -e "${YELLOW}[BİLGİ]${NC} Manuel kurulum için: sudo apt install pipx"
        return 1
    fi
}

# Install UV (Ultra-fast Python package installer)
install_uv() {
    echo -e "\n${BLUE}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}[BİLGİ]${NC} UV (Ultra-fast Python package installer) kurulumu başlatılıyor..."
    echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"

    echo -e "${YELLOW}[BİLGİ]${NC} UV kuruluyor..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Add Cargo bin to PATH
    export PATH="$HOME/.cargo/bin:$PATH"

    # Update shell RC files
    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
        if [ -f "$rc_file" ]; then
            if ! grep -q '.cargo/bin' "$rc_file"; then
                echo '' >> "$rc_file"
                echo "export PATH=\"$HOME/.cargo/bin:\$PATH\"" >> "$rc_file"
            fi
        fi
    done

    # Source cargo env if exists
    source "$HOME/.cargo/env" 2>/dev/null || true

    if command -v uv &> /dev/null; then
        echo -e "${GREEN}[BAŞARILI]${NC} UV kurulumu tamamlandı: $(uv --version)"
        echo -e "\n${CYAN}[BİLGİ]${NC} UV Kullanım İpuçları:"
        echo -e "  ${GREEN}•${NC} Paket kurma: ${GREEN}uv pip install paket_adi${NC}"
        echo -e "  ${GREEN}•${NC} Sanal ortam oluşturma: ${GREEN}uv venv${NC}"
        echo -e "  ${GREEN}•${NC} Python kurma: ${GREEN}uv python install 3.12${NC}"
    else
        echo -e "${RED}[HATA]${NC} UV kurulumu başarısız!"
        return 1
    fi
}

# Export functions for use in other modules
export -f install_python
export -f install_pip
export -f install_pipx
export -f install_uv