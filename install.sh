#!/bin/bash

# 1453.AI WSL Kurulum Betiği Yükleyici
# Bu betik modüler WSL kurulum betiğini indirir ve kurar

set -e

# Renkli çıktı için tanımlamalar
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Renk Yok

# GitHub depo bilgileri
REPO_OWNER="altudev"
REPO_NAME="1453-wsl-bash-script"
BRANCH="master"
BASE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}"

# Kurulum dizini
INSTALL_DIR="$HOME/.1453-wsl-setup"

# ASCII Art Banner
show_banner() {
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
    echo -e "${BLUE}║      1453.AI WSL Kurulum Betiği - Hızlı Yükleyici            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

# Dosya indirme fonksiyonu
download_file() {
    local url="$1"
    local dest="$2"
    local desc="$3"

    echo -e "${YELLOW}[İNDİRİLİYOR]${NC} $desc"
    if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
        echo -e "${GREEN}[✓]${NC} $desc"
        return 0
    else
        echo -e "${RED}[✗]${NC} İndirilemedi: $desc"
        return 1
    fi
}

# Ana kurulum fonksiyonu
main() {
    clear
    show_banner

    echo -e "${CYAN}[BİLGİ]${NC} 1453.AI WSL Kurulum Betiği Yüklemesi Başlatılıyor..."
    echo -e "${CYAN}[BİLGİ]${NC} Kurulum dizini: ${INSTALL_DIR}"
    echo ""

    # curl kontrolü
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}[HATA]${NC} curl gerekli ama kurulu değil."
        echo -e "${YELLOW}[İPUCU]${NC} curl'ü kurmak için: sudo apt install curl"
        exit 1
    fi

    # Kurulum dizin yapısını oluştur
    echo -e "${YELLOW}[KURULUM]${NC} Dizin yapısı oluşturuluyor..."
    mkdir -p "${INSTALL_DIR}/src"/{lib,config,modules}
    echo -e "${GREEN}[✓]${NC} Dizin yapısı oluşturuldu"
    echo ""

    # İndirilecek dosyaların listesi
    declare -a files=(
        "src/linux-ai-setup-script.sh:Ana betik"
        "src/lib/init.sh:Başlatma modülü"
        "src/lib/common.sh:Ortak araçlar"
        "src/lib/package-manager.sh:Paket yöneticisi tespiti"
        "src/config/colors.sh:Renk tanımlamaları"
        "src/config/php-versions.sh:PHP yapılandırması"
        "src/config/banner.sh:Banner gösterimi"
        "src/modules/python.sh:Python ekosistemi"
        "src/modules/javascript.sh:JavaScript ekosistemi"
        "src/modules/php.sh:PHP ekosistemi"
        "src/modules/ai-cli.sh:AI CLI araçları"
        "src/modules/ai-frameworks.sh:AI framework'leri"
        "src/modules/menus.sh:Menü sistemi"
    )

    # Tüm dosyaları indir
    echo -e "${CYAN}[BİLGİ]${NC} Modüler bileşenler indiriliyor..."
    echo ""

    local failed=0
    for file_info in "${files[@]}"; do
        IFS=':' read -r file_path description <<< "$file_info"
        local url="${BASE_URL}/${file_path}"
        local dest="${INSTALL_DIR}/${file_path}"

        if ! download_file "$url" "$dest" "$description"; then
            ((failed++))
        fi
    done

    echo ""

    if [ $failed -gt 0 ]; then
        echo -e "${RED}[HATA]${NC} $failed dosya indirilemedi."
        echo -e "${YELLOW}[İPUCU]${NC} Tekrar deneyebilir veya depoyu doğrudan klonlayabilirsiniz:"
        echo -e "      git clone https://github.com/${REPO_OWNER}/${REPO_NAME}.git"
        exit 1
    fi

    # Ana betiği çalıştırılabilir yap
    chmod +x "${INSTALL_DIR}/src/linux-ai-setup-script.sh"

    # Kullanışlı bir başlatıcı betiği oluştur
    echo -e "${YELLOW}[KURULUM]${NC} Başlatıcı betiği oluşturuluyor..."
    cat > "${INSTALL_DIR}/1453-setup" << 'LAUNCHER'
#!/bin/bash
# 1453.AI WSL Kurulum Başlatıcı
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "${SCRIPT_DIR}/src/linux-ai-setup-script.sh" "$@"
LAUNCHER

    chmod +x "${INSTALL_DIR}/1453-setup"
    echo -e "${GREEN}[✓]${NC} Başlatıcı betiği oluşturuldu"
    echo ""

    # Kurulum başarılı mesajı
    echo -e "${CYAN}[BİLGİ]${NC} Kurulum başarıyla tamamlandı!"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    Kurulum Tamamlandı!                        ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Kurulum betiğini çalıştırmak için şu yöntemlerden birini kullanın:${NC}"
    echo ""
    echo -e "  1. Doğrudan çalıştırma:"
    echo -e "     ${GREEN}${INSTALL_DIR}/1453-setup${NC}"
    echo ""
    echo -e "  2. PATH'e ekleyerek kolay erişim (isteğe bağlı):"
    echo -e "     ${GREEN}echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.bashrc${NC}"
    echo -e "     ${GREEN}source ~/.bashrc${NC}"
    echo -e "     ${GREEN}1453-setup${NC}"
    echo ""
    echo -e "  3. Takma ad (alias) oluşturma (isteğe bağlı):"
    echo -e "     ${GREEN}echo 'alias 1453=\"${INSTALL_DIR}/1453-setup\"' >> ~/.bashrc${NC}"
    echo -e "     ${GREEN}source ~/.bashrc${NC}"
    echo -e "     ${GREEN}1453${NC}"
    echo ""
    echo -e "${CYAN}[İPUCU]${NC} Betik şu dizinde kurulu: ${INSTALL_DIR}"
    echo -e "${CYAN}[İPUCU]${NC} Güncellemek için bu yükleyiciyi tekrar çalıştırın"
    echo ""

    # Kullanıcıya kurulum betiğini şimdi çalıştırmak isteyip istemediğini sor
    echo -e "${YELLOW}════════════════════════════════════════════════════════════════${NC}"
    echo -ne "${YELLOW}Kurulum betiğini şimdi çalıştırmak ister misiniz? (e/E=Evet, Enter=Hayır): ${NC}"

    # stdin'i terminal'e yönlendir (pipe'dan okuma sorunu için)
    if [ -t 0 ]; then
        read -r response
    else
        read -r response </dev/tty
    fi

    if [[ "$response" =~ ^[eE]$ ]]; then
        echo ""
        echo -e "${GREEN}[BİLGİ]${NC} Kurulum betiği başlatılıyor..."
        exec "${INSTALL_DIR}/1453-setup"
    else
        echo ""
        echo -e "${CYAN}[BİLGİ]${NC} Kurulum betiğini daha sonra çalıştırabilirsiniz:"
        echo -e "${GREEN}${INSTALL_DIR}/1453-setup${NC}"
        echo ""
    fi
}

# Yükleyiciyi çalıştır
main "$@"