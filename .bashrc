[ -n "$PS1" ] && source ~/.bash_profile

# HSTR configuration - moved to .exports
alias hh=hstr                    # hh to be alias for hstr
shopt -s histappend              # append new history items to .bash_history
# ensure synchronization between Bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

# NVM configuration moved to .exports
