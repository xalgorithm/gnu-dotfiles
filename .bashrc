
[ -n "$PS1" ] && source ~/.bash_profile
# Include Drush completion.
if [ -f "$HOME/.drush/drush.complete.sh" ] ; then
  source $HOME/.drush/drush.complete.sh
fi

# Include Drush prompt customizations.
if [ -f "$HOME/.drush/drush.prompt.sh" ] ; then
  source $HOME/.drush/drush.prompt.sh
fi



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/xalg/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/xalg/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/xalg/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/xalg/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

