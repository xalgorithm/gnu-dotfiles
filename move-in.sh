#!/usr/bin/env bash
set -e

# move-in.sh
# Bootstrap script to setup the environment on macOS, Debian/Ubuntu, or CentOS.

DOTFILES_REPO="https://github.com/xalgorithm/gnu-dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

log() {
    echo -e "\033[1;32m[MOVE-IN]\033[0m $1"
}

error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
    exit 1
}

# ------------------------------------------------------------------------------
# 1. OS Detection
# ------------------------------------------------------------------------------
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ "$ID" == "debian" || "$ID" == "ubuntu" ]]; then
            OS="debian"
        elif [[ "$ID" == "centos" || "$ID" == "rhel" || "$ID" == "fedora" ]]; then
            OS="centos"
        else
            OS="linux_generic"
        fi
    else
        error "Unsupported Operating System."
    fi
    log "Detected OS: $OS"
}

# ------------------------------------------------------------------------------
# 2. Package Manager Setup
# ------------------------------------------------------------------------------
setup_pkg_manager() {
    if [[ "$OS" == "macos" ]]; then
        if ! command -v brew &>/dev/null; then
            log "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Add brew to path for this session
            eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
        else
            log "Homebrew already installed."
        fi
    fi
}

# ------------------------------------------------------------------------------
# 3. Git Installation
# ------------------------------------------------------------------------------
install_git() {
    if command -v git &>/dev/null; then
        log "Git is already installed."
        return
    fi

    log "Installing Git..."
    case "$OS" in
        macos) brew install git ;;
        debian) sudo apt-get update && sudo apt-get install -y git ;;
        centos) sudo dnf install -y git ;;
        *) error "Cannot install git automatically on this OS." ;;
    esac
}

# ------------------------------------------------------------------------------
# 4. Dotfiles Setup
# ------------------------------------------------------------------------------
setup_dotfiles() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        log "Dotfiles directory exists. Pulling latest..."
        cd "$DOTFILES_DIR" && git pull
    else
        log "Cloning dotfiles from $DOTFILES_REPO..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi

    log "Symlinking configuration..."
    # Backup and Remove existing
    for file in .bashrc .bash_profile; do
        if [[ -f "$HOME/$file" && ! -L "$HOME/$file" ]]; then
            mv "$HOME/$file" "$HOME/${file}.backup_$(date +%s)"
            log "Backed up existing $file"
        fi
        rm -f "$HOME/$file"
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
        log "Linked $file -> $DOTFILES_DIR/$file"
    done
}

# ------------------------------------------------------------------------------
# 5. Dependency Installation
# ------------------------------------------------------------------------------
install_dependencies() {
    log "Installing dependencies for $OS..."

    case "$OS" in
        macos)
            brew update
            # Core
            brew install git jq hstr starship eza bat ripgrep fd zoxide wget
            # Cloud
            brew install awscli google-cloud-sdk terraform ansible
            # Kubernetes
            brew install kubecolor
            # Utils
            brew install fzf
            $(brew --prefix)/opt/fzf/install --all
            ;;

        debian)
            sudo apt-get update
            # Basics
            sudo apt-get install -y build-essential curl wget jq nfs-common unzip
            
            # Modern Tools (Manual/Script installs often needed for latest versions)
            # Starship
            curl -sS https://starship.rs/install.sh | sh -s -- -y
            
            # Smart OS tools install (trying to be generic but effective)
            if command -v snap &>/dev/null; then
                sudo snap install aws-cli --classic || true
                sudo snap install google-cloud-cli --classic || true
            else
                # Fallback AWS
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                unzip -q awscliv2.zip && sudo ./aws/install || true
                rm -rf aws awscliv2.zip
            fi
            
            # HSTR
            if ! command -v hstr &>/dev/null; then
                 sudo add-apt-repository -y ppa:ultradvorka/ppa && sudo apt-get update && sudo apt-get install -y hstr || true
            fi
            ;;
            
        centos)
            sudo dnf install -y epel-release
            sudo dnf install -y git jq nfs-utils hstr unzip
            
            # Starship
            curl -sS https://starship.rs/install.sh | sh -s -- -y
            
            # AWS
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            unzip -q awscliv2.zip && sudo ./aws/install || true
            rm -rf aws awscliv2.zip
            ;;
    esac
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    detect_os
    setup_pkg_manager
    install_git
    setup_dotfiles
    install_dependencies
    
    log "Initialization complete!"
    log "Please restart your shell or run: source ~/.bash_profile"
}

main
