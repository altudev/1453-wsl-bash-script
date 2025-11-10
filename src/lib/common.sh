#!/bin/bash
# Common Utility Functions
# This file contains shared utilities used across all modules

# Reload shell configuration files
# Usage: reload_shell_configs [mode]
# mode: "verbose" (default) or "silent"
reload_shell_configs() {
    local mode="${1:-verbose}"
    local candidates=()
    local shell_name
    shell_name=$(basename "${SHELL:-}")

    case "$shell_name" in
        zsh)
            candidates=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile")
            ;;
        bash)
            candidates=("$HOME/.bashrc" "$HOME/.profile" "$HOME/.zshrc")
            ;;
        *)
            candidates=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile")
            ;;
    esac

    local sourced_file=""
    for rc_file in "${candidates[@]}"; do
        if [ -f "$rc_file" ]; then
            # shellcheck source=/dev/null
            . "$rc_file" && sourced_file="$rc_file" && break
        fi
    done

    if [ "$mode" = "silent" ]; then
        return
    fi

    if [ -n "$sourced_file" ]; then
        echo -e "${GREEN}[BİLGİ]${NC} Shell yapılandırmaları otomatik olarak yüklendi (${sourced_file})."
    else
        echo -e "${YELLOW}[UYARI]${NC} Shell yapılandırma dosyaları bulunamadı; gerekirse terminalinizi yeniden başlatın."
    fi
}

# Mask sensitive data for display
# Usage: mask_secret "sensitive_string"
# Shows first 4 and last 4 characters, masks the middle
mask_secret() {
    local secret="$1"
    local length=${#secret}
    if [ "$length" -le 8 ]; then
        echo "$secret"
        return
    fi

    local prefix=${secret:0:4}
    local suffix=${secret: -4}
    local middle_length=$((length - 8))
    local mask=""
    while [ ${#mask} -lt "$middle_length" ]; do
        mask="${mask}*"
    done
    echo "${prefix}${mask}${suffix}"
}

# Export functions for use in other modules
export -f reload_shell_configs
export -f mask_secret