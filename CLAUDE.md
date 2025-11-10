# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a WSL (Windows Subsystem for Linux) automated setup script designed for AI developers. The project has been refactored from a single monolithic script into a modular architecture for better maintainability and organization. It installs and configures development tools, programming languages, and AI CLI tools in a Linux environment.

## Core Commands

### Running the Main Script
```bash
# Make the script executable
chmod +x src/linux-ai-setup-script.sh

# Run the script
./src/linux-ai-setup-script.sh

# Or run with bash directly
bash src/linux-ai-setup-script.sh
```

### Script Validation
```bash
# Check for syntax errors
bash -n src/linux-ai-setup-script.sh

# Run shellcheck for linting (if installed)
shellcheck src/linux-ai-setup-script.sh
```

## Architecture

### Version 2.0 - Modular Architecture

The project has been refactored from a 2,331-line monolithic script into a clean modular architecture:

```
src/
├── linux-ai-setup-script.sh        # Main entry point (52 lines)
├── linux-ai-setup-script-legacy.sh # Original monolithic script (backup)
│
├── lib/                            # Core libraries
│   ├── init.sh                    # CRLF detection and initialization
│   ├── common.sh                  # Shared utilities (reload_shell_configs, mask_secret)
│   └── package-manager.sh        # Package manager detection and system updates
│
├── config/                         # Configuration files
│   ├── colors.sh                  # Terminal color definitions
│   ├── php-versions.sh            # PHP version and extension arrays
│   └── banner.sh                  # ASCII art and banner display
│
└── modules/                        # Feature modules
    ├── python.sh                  # Python ecosystem (Python, pip, pipx, UV)
    ├── javascript.sh              # JavaScript ecosystem (NVM, Bun.js)
    ├── php.sh                     # PHP ecosystem (PHP versions, Composer, Laravel)
    ├── ai-cli.sh                  # AI CLI tools (Claude Code, Gemini, Qwen, etc.)
    ├── ai-frameworks.sh           # AI frameworks (SuperGemini, SuperQwen, SuperClaude)
    └── menus.sh                   # Interactive menu system and main loop
```

### Module Categories
1. **Core Libraries** (`lib/`) - System initialization, shared utilities, package management
2. **Configuration** (`config/`) - Colors, PHP versions, banner/branding
3. **Python Ecosystem** (`modules/python.sh`) - Python, pip, pipx, UV with PEP 668 compliance
4. **JavaScript Ecosystem** (`modules/javascript.sh`) - NVM and Bun.js installation
5. **PHP Ecosystem** (`modules/php.sh`) - Multiple PHP versions (7.4-8.5) with Laravel support
6. **AI CLI Tools** (`modules/ai-cli.sh`) - Claude Code, Gemini, Qwen, OpenCode, Copilot, GitHub CLI
7. **AI Frameworks** (`modules/ai-frameworks.sh`) - SuperGemini, SuperQwen, SuperClaude
8. **Interactive Menus** (`modules/menus.sh`) - Menu-driven interface with multi-choice support

### Key Implementation Details

**Package Manager Detection**: The script automatically detects and supports:
- APT (Debian/Ubuntu)
- DNF (Fedora/RHEL 8+)
- YUM (RHEL/CentOS)
- Pacman (Arch Linux)

**Shell Configuration Management**: Automatically modifies and reloads:
- `.bashrc`
- `.zshrc`
- `.profile`

**Windows WSL Compatibility**: Handles CRLF line endings automatically at startup using `dos2unix`, `sed`, or `tr`.

**Error Handling**: Uses color-coded output (RED for errors, GREEN for success, YELLOW for warnings) with bilingual messages (Turkish/English).

## Important Functions

### Core Functions (lib/)
- `detect_package_manager()` - Detects system package manager (`lib/package-manager.sh`)
- `reload_shell_configs()` - Reloads shell configuration files (`lib/common.sh`)
- `update_system()` - Updates system packages (`lib/package-manager.sh`)
- `mask_secret()` - Masks sensitive data for display (`lib/common.sh`)

### Python Functions (modules/python.sh)
- `install_python()` - Installs Python with modern pip handling
- `install_pip()` - Installs/updates pip with PEP 668 compliance
- `install_pipx()` - Installs pipx for isolated Python applications
- `install_uv()` - Installs UV fast Python package manager

### JavaScript Functions (modules/javascript.sh)
- `install_nvm()` - Installs Node Version Manager
- `install_bun()` - Installs Bun.js runtime

### PHP Functions (modules/php.sh)
- `ensure_php_repository()` - Configures PHP repositories
- `install_php_version()` - Installs specific PHP version with extensions
- `install_composer()` - Installs Composer package manager
- `install_php_version_menu()` - Interactive PHP version selection

### AI CLI Functions (modules/ai-cli.sh)
- `install_claude_code()` - Installs Claude Code CLI
- `install_gemini_cli()` - Installs Gemini CLI
- `install_github_cli()` - Installs GitHub CLI
- `install_ai_cli_tools_menu()` - Interactive AI tools menu

### AI Framework Functions (modules/ai-frameworks.sh)
- `install_supergemini()` - Installs SuperGemini framework
- `install_superqwen()` - Installs SuperQwen framework
- `install_superclaude()` - Installs SuperClaude framework
- `install_ai_frameworks_menu()` - Interactive frameworks menu

### Menu System (modules/menus.sh)
- `configure_git()` - Interactive Git configuration
- `show_menu()` - Main interactive menu display
- `main()` - Main program loop with multi-choice support

## Development Notes

### Working with the Modular Architecture
When modifying the script:
1. **Identify the correct module** - Determine which module your changes belong to
2. **Maintain module boundaries** - Keep functions in their appropriate modules
3. **Use shared utilities** - Leverage functions in `lib/common.sh` for common tasks
4. **Follow the loading order** - Ensure dependencies are loaded before dependent modules
5. **Test module independently** - Source and test individual modules when possible

### Module Loading Order
The main script loads modules in this specific order:
1. `lib/init.sh` - CRLF detection (must be first)
2. Configuration files (`config/*.sh`)
3. Core libraries (`lib/*.sh`)
4. Feature modules (`modules/*.sh`)
5. Menu system last (depends on all other modules)

### Adding New Tools
To add a new installation function:
1. **Choose the appropriate module** - Add to existing module or create new one
2. **Create function** following naming pattern `install_<tool_name>()`
3. **Check if tool exists** before installation using `command -v`
4. **Add PATH modifications** to appropriate shell RC files
5. **Call `reload_shell_configs()`** after installation
6. **Update menu** - Add entry in `modules/menus.sh` if needed
7. **Export function** - Add `export -f function_name` at module end

### PHP Version Management
The script uses `update-alternatives` for PHP version switching. When adding new PHP versions:
1. Add version to `PHP_SUPPORTED_VERSIONS` array
2. Ensure all extensions in `PHP_EXTENSION_PACKAGES` are installed
3. Configure alternatives in `install_php_version()`

### MCP Server Integration
MCP (Model Context Protocol) servers are managed through:
- `cleanup_magic_mcp()` - SuperGemini servers
- `cleanup_qwen_mcp()` - SuperQwen servers
- `cleanup_claude_mcp()` - SuperClaude servers

## Testing Approach

No automated tests exist. Manual testing approach:

### Syntax Validation
```bash
# Test main script syntax
bash -n src/linux-ai-setup-script.sh

# Test all modules at once
for file in src/{lib,config,modules}/*.sh; do
    echo "Checking: $file"
    bash -n "$file"
done

# Run shellcheck for linting (if installed)
shellcheck src/linux-ai-setup-script.sh src/{lib,config,modules}/*.sh
```

### Module Testing
```bash
# Test individual module by sourcing dependencies
source src/config/colors.sh
source src/lib/common.sh
source src/lib/package-manager.sh
source src/modules/python.sh

# Test specific function
install_python
```

### Integration Testing
```bash
# Test in Docker container (recommended)
docker run -it ubuntu:latest /bin/bash
# Copy entire src/ directory and test

# Run the modular script
./src/linux-ai-setup-script.sh

# Compare with legacy script behavior
./src/linux-ai-setup-script-legacy.sh
```

## Common Issues and Solutions

1. **CRLF Line Endings**: Script auto-fixes on first run
2. **Permission Denied**: Run `chmod +x` on the script
3. **PEP 668 Errors**: Script handles externally-managed-environment automatically
4. **Missing Dependencies**: Script installs prerequisites automatically
5. **Shell Not Reloading**: Script calls `reload_shell_configs()` automatically