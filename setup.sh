#!/bin/bash

# setup.sh - E2FACE Auto Installer
# Automatically installs e2face and makes it available system-wide
# GitHub: https://github.com/InetByOu/e2face.git

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GITHUB_REPO="https://github.com/InetByOu/e2face.git"
TEMP_DIR="/tmp/e2face_install"
SCRIPT_NAME="e2face"
INSTALL_PATH="/usr/bin/e2face"

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_step() { echo -e "${BLUE}[STEP]${NC} $1"; }

show_header() {
    clear
    echo "================================================================"
    echo -e "${BLUE}           E2FACE AUTO SETUP INSTALLER${NC}"
    echo "================================================================"
    echo
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root!"
        echo "Please run: sudo $0"
        exit 1
    fi
}

check_dependencies() {
    print_step "Checking dependencies..."
    
    # Check for git
    if ! command -v git >/dev/null 2>&1; then
        print_status "Installing git..."
        opkg update >/dev/null 2>&1
        if opkg install git >/dev/null 2>&1; then
            print_status "Git installed successfully"
        else
            print_error "Failed to install git"
            return 1
        fi
    fi
    
    # Check for curl
    if ! command -v curl >/dev/null 2>&1; then
        print_status "Installing curl..."
        if opkg install curl >/dev/null 2>&1; then
            print_status "cURL installed successfully"
        else
            print_warning "cURL installation failed (optional)"
        fi
    fi
    
    # Verify git installation
    if ! command -v git >/dev/null 2>&1; then
        print_error "Git is not available and cannot be installed"
        return 1
    fi
    
    print_status "Dependencies: OK"
    return 0
}

clone_repository() {
    print_step "Downloading E2FACE from GitHub..."
    
    # Clean up any previous temp directory
    cleanup_temp
    
    # Clone repository
    if git clone "$GITHUB_REPO" "$TEMP_DIR" 2>/dev/null; then
        print_status "Repository cloned successfully"
        return 0
    else
        print_error "Failed to clone repository"
        return 1
    fi
}

install_e2face() {
    print_step "Installing E2FACE script..."
    
    # Check if e2face script exists in cloned repo
    if [ -f "$TEMP_DIR/e2face" ]; then
        # Copy to system location
        cp "$TEMP_DIR/e2face" "$INSTALL_PATH"
        chmod +x "$INSTALL_PATH"
        
        if [ -f "$INSTALL_PATH" ]; then
            print_status "E2FACE script installed to $INSTALL_PATH"
            return 0
        else
            print_error "Failed to install E2FACE script"
            return 1
        fi
    else
        print_error "E2FACE script not found in cloned repository"
        return 1
    fi
}

create_symlink() {
    print_step "Creating system symlinks..."
    
    # Create symlink in /usr/local/bin (common location)
    if [ ! -L "/usr/local/bin/e2face" ]; then
        ln -s "$INSTALL_PATH" /usr/local/bin/e2face 2>/dev/null
        print_status "Symlink created: /usr/local/bin/e2face"
    fi
    
    # Create symlink in /bin (fallback)
    if [ ! -L "/bin/e2face" ]; then
        ln -s "$INSTALL_PATH" /bin/e2face 2>/dev/null
        print_status "Symlink created: /bin/e2face"
    fi
}

setup_autocomplete() {
    print_step "Setting up bash completion..."
    
    # Create bash completion script
    cat > /etc/bash_completion.d/e2face << 'EOF'
_e2face() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--auto --manual --status --test --interfaces --update --help"
    
    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}
complete -F _e2face e2face
EOF

    if [ -f "/etc/bash_completion.d/e2face" ]; then
        print_status "Bash completion installed"
    else
        print_warning "Bash completion setup failed (optional)"
    fi
}

cleanup_temp() {
    if [ -d "$TEMP_DIR" ]; then
        print_step "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
        print_status "Temporary files cleaned up"
    fi
}

verify_installation() {
    print_step "Verifying installation..."
    
    # Test if e2face is available
    if command -v e2face >/dev/null 2>&1; then
        # Test if script works
        if e2face --help >/dev/null 2>&1; then
            print_status "E2FACE is now available system-wide"
            echo
            echo -e "${GREEN}Installation successful!${NC}"
            echo
            echo "You can now use:"
            echo "  e2face                    # Interactive menu"
            echo "  e2face --auto             # Auto setup dual WAN"
            echo "  e2face --manual           # Manual setup"
            echo "  e2face --status           # Show status"
            echo "  e2face --test             # Test configuration"
            echo "  e2face --interfaces       # Show interface info"
            echo "  e2face --update           # Check for updates"
            echo "  e2face --help             # Show help"
            echo
            return 0
        else
            print_error "E2FACE script is not working properly"
            return 1
        fi
    else
        print_error "E2FACE command not found!"
        return 1
    fi
}

show_usage() {
    echo "E2FACE Auto Setup Installer"
    echo
    echo "Usage:"
    echo "  ./setup.sh          # Install E2FACE system-wide"
    echo "  ./setup.sh --help   # Show this help"
    echo
    echo "This script will:"
    echo "  1. Clone repository from GitHub"
    echo "  2. Install e2face to /usr/bin/"
    echo "  3. Create symlinks for system-wide access"
    echo "  4. Setup bash completion"
    echo "  5. Clean up temporary files"
    echo
}

main() {
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_usage
        exit 0
    fi
    
    show_header
    check_root
    
    print_step "Starting E2FACE auto setup..."
    echo
    
    # Set up cleanup on exit
    trap cleanup_temp EXIT
    
    if check_dependencies && \
       clone_repository && \
       install_e2face && \
       create_symlink && \
       setup_autocomplete; then
        
        # Clean up temporary files
        cleanup_temp
        
        echo
        if verify_installation; then
            echo "================================================================"
            print_status "E2FACE installation completed successfully!"
            echo "================================================================"
            echo
            print_status "Repository files cleaned up"
            print_status "Try it now by typing: e2face --help"
            echo
        else
            print_error "Installation completed with errors"
            exit 1
        fi
    else
        print_error "Installation failed"
        # Clean up on failure
        cleanup_temp
        exit 1
    fi
}

# Run main function
main "$@"
