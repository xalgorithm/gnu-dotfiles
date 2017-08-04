

[ -n "$PS1" ] && source ~/.bash_profile
# Include Drush completion.
if [ -f "/Users/xalg/.drush/drush.complete.sh" ] ; then
  source /Users/xalg/.drush/drush.complete.sh
fi

# Include Drush prompt customizations.
if [ -f "/Users/xalg/.drush/drush.prompt.sh" ] ; then
  source /Users/xalg/.drush/drush.prompt.sh
fi


source /etc/bash_completion.d/climate_completion