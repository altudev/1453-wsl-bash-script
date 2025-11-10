#!/bin/bash
# Initialization and CRLF Self-Healing
# This file must be sourced first to handle Windows line ending issues

# Windows CRLF düzeltme kontrolü
# Not: bash -n sadece syntax kontrolü yapar, CRLF düzeltmesini çalıştırmaz
# CRLF'li dosyayı düzeltmek için önce: dos2unix script.sh veya sed -i 's/\r$//' script.sh

# Only run CRLF check if we're running the main script directly
if [ -f "$0" ] && [ "$(basename "$0")" = "linux-ai-setup-script.sh" ]; then
    # file komutu olmayabilir, od ile kontrol et
    if (command -v file &> /dev/null && file "$0" | grep -q "CRLF") || \
       (command -v od &> /dev/null && od -c "$0" 2>/dev/null | head -20 | grep -q $'\r'); then
        echo "Windows satır sonu karakterleri tespit edildi, düzeltiliyor..."

        if command -v dos2unix &> /dev/null; then
            dos2unix "$0"
        elif command -v sed &> /dev/null; then
            sed -i 's/\r$//' "$0"
        elif command -v tr &> /dev/null; then
            tr -d '\r' < "$0" > "$0.tmp" && mv "$0.tmp" "$0"
        else
            echo "UYARI: CRLF düzeltme araçları bulunamadı (dos2unix, sed veya tr)"
            echo "Manuel düzeltme için: sed -i 's/\r$//' $0"
            exit 1
        fi

        chmod +x "$0"

        echo "Düzeltme tamamlandı, script yeniden başlatılıyor..."
        exec bash "$0" "$@"
    fi
fi

# Get the absolute path of the script directory
# This is used by all modules to source other files
if [ -z "${SCRIPT_DIR}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    export SCRIPT_DIR
fi

# Ensure we're running with bash
if [ -z "${BASH_VERSION}" ]; then
    echo "Error: This script must be run with bash, not sh"
    exit 1
fi