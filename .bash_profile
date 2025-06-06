# Source dot files in a specific order to avoid conflicts
# The order is important:
# 1. .bash_prompt - so prompt is configured early
# 2. .exports - so environment variables are available to other scripts
# 3. .functions - so functions are available to aliases
# 4. .aliases - depends on functions
# 5. .kube-aliases - specific Kubernetes aliases
# 6. .extra - user's personal overrides (not tracked in git)

# Function to source a file if it exists
source_if_exists() {
	[ -r "$1" ] && source "$1"
}

# Source core configuration files
for file in ~/.dotfiles/{.bash_prompt,.exports,.functions,.aliases,.kube-aliases}; do
	source_if_exists "$file"
done

# Source Docker aliases if they exist
source_if_exists ~/.docker/aliases

# Source private configurations (not tracked in git)
source_if_exists ~/.extra

# Shell Options
# -------------

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config
if [ -e "$HOME/.ssh/config" ]; then
	complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh
fi

# Ruby environment
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Homebrew
if command -v brew &>/dev/null; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	
	# Homebrew bash completion
	HOMEBREW_PREFIX="$(brew --prefix)"
	if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
		source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
	else
		for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
			[[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
		done
	fi
fi

# Conda environment
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
