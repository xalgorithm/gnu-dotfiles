# Dotfiles

My personal dotfiles for macOS development environment.

## Features

- Bash configuration with useful aliases and functions
- Git configuration
- Kubernetes aliases and functions
- Docker utilities
- AWS and cloud platform integration
- Customized terminal prompt

## Installation

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Structure

- `.aliases` - Command shortcuts and aliases
- `.bash_profile` - Main bash configuration file
- `.bashrc` - Minimal bashrc that sources bash_profile
- `.functions` - Utility bash functions
- `.exports` - Environment variables
- `.bash_prompt` - Custom terminal prompt
- `docker-aliases` - Docker-specific shortcuts
- `.kube-aliases` - Kubernetes shortcuts

## Customization

Add your own custom settings to `.extra` which is sourced but not tracked in the repo. 