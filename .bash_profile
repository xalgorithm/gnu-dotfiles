# Source dot files in a specific order to avoid conflicts
# 1. .bash_prompt
# 2. .exports
# 3. .functions
# 4. .aliases
# 5. .kube-aliases
# 6. .extra

source_if_exists() {
    [ -r "$1" ] && source "$1"
}

# Core Source Loop
for file in ~/.dotfiles/{.bash_prompt,.exports,.functions,.aliases,.kube-aliases}; do
    source_if_exists "$file"
done

# Docker
source_if_exists ~/.docker/aliases

# Private/Extra
source_if_exists ~/.extra

# Shell Options
fastfetch
shopt -s nocaseglob
shopt -s histappend
shopt -s cdspell
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Tab Completions
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F _git g;
fi;

if [ -e "$HOME/.ssh/config" ]; then
    complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh
fi

# Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Homebrew Completion
if command -v brew &>/dev/null; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
        done
    fi
fi

# Conda
if [ -f "/opt/homebrew/anaconda3/bin/conda" ]; then
    __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi

complete -C /opt/homebrew/bin/vault vault

# OrbStack
source ~/.orbstack/shell/init.bash 2>/dev/null || :

# Load Angular CLI autocompletion
source <(ng completion script)

# Starship Prompt
eval "$(starship init bash)"

# Zoxide (Smarter cd)
eval "$(zoxide init bash)"
